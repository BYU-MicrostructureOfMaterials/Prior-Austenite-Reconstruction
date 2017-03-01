%Format of grainfile type 2 is enforced. Must be square grid and have 
%following rows in header:
% 
% # Column 1: Integer identifying grain
% # Column 2-4: Average orientation (phi1, PHI, phi2) in radians
% # Column 5-6: Average Position (x, y) in microns
% # Column 7: Average Image Quality (IQ)
% # Column 8: Average Confidence Index (CI)
% # Column 9: Average Fit (degrees)
% # Column 10: An integer identifying the phase
% #           0 - 'phase 1 name'
%             1 - 'phase 2 name'
%             ...
% # Column 11: Number of measurement points in the grain

function [] = read_grain_file_type_2(obj,filename)

fid = fopen(filename,'rt');

%Extract header
linecount = 0;
inheader = 1;
while inheader
    line = fgetl(fid);
    
    if line(1)=='#'
        linecount = linecount + 1;
        header{linecount} = line;
    else
        inheader = 0;
    end
end

%Check for square grid format
%Read in file data
filedata = ReadGrainFile(filename);

Xcoordinates = filedata{4};
Ycoordinates = filedata{5};

%%Use a while to find the next row and compare the initial x values of
%%row 1 and 2 to see if it is a Hex or Square Scan

difference=0;
rowcount = 1;

while (difference==0)
    
    difference = Ycoordinates(1,1) - Ycoordinates(rowcount,1);
    rowcount = rowcount + 1;
   
end

% remove the extra 1 added on by the last iteration of the while love

rowcount = rowcount - 1;

issquare = Xcoordinates(1,1)-Xcoordinates((rowcount),1);
if issquare ~= 0, error('Input grain file must be of square scan. Convert to square scan first.'); end

%Check column data format. Must have following lines in header:
format{1} = '# Column 1: Integer identifying grain';
format{2} = '# Column 2-4: Average orientation (phi1, PHI, phi2) in radians';
format{3} = '# Column 5-6: Average Position (x, y) in microns';
format{4} = '# Column 7: Average Image Quality (IQ)';
format{5} = '# Column 8: Average Confidence Index (CI)';
format{6} = '# Column 9: Average Fit (degrees)';
format{7} = '# Column 10: An integer identifying the phase';
format{8} = '# Column 11: Number of measurement points in the grain';

formatcheck = ismember(format,header);
if any(formatcheck==0), error('Incorrect format. Check grain file header and verify that required rows match expected format.'); end

%Extract phase names and integer IDs to form a key
lineAbovePhases = find(~cellfun('isempty',strfind(header,format{7})));
lineBelowPhases = find(~cellfun('isempty',strfind(header,format{8})));
phaseIDrange = lineAbovePhases+1:lineBelowPhases-1;

phasecount = 1;
for i=phaseIDrange
    phaseline = header{i};
    phaseTokens = strsplit(phaseline,{' ','-','#'});
    phaseTokens = phaseTokens(~cellfun('isempty',phaseTokens));
    
    phaseID(phasecount) = int32(str2double(phaseTokens{1}));
    phasename{phasecount} = strjoin(phaseTokens(2:length(phaseTokens)));
    phasecount = phasecount + 1;
    
end

obj.phasekey = table(phaseID(:),phasename(:),'VariableNames',{'phaseID' 'phasename'});

%Read grain data
filedata = ReadGrainFile(filename);

OIMgid = int32(filedata{1});
avgphi1 = filedata{2};
avgPHI = filedata{3};
avgphi2 = filedata{4};
avgx = filedata{5};
avgy = filedata{6};
avgIQ = filedata{7};
avgCI = filedata{8};
avgfit = filedata{9};
phaseID = int32(filedata{10});
npnts = int32(filedata{11});

obj.graindata = table(OIMgid,avgphi1,avgPHI,avgphi2,avgx,avgy,avgIQ,avgCI,avgfit,phaseID,npnts);


% for i=1:length(filedata{1})
% 
%     obj.graindata(i).OIMgid = int32(filedata{1}(i));
%     obj.graindata(i).avgphi1 = filedata{2}(i);
%     obj.graindata(i).avgPHI = filedata{3}(i);
%     obj.graindata(i).avgphi2 = filedata{4}(i);
%     obj.graindata(i).avgx = filedata{5}(i);
%     obj.graindata(i).avgy = filedata{6}(i);
%     obj.graindata(i).avgIQ = filedata{7}(i);
%     obj.graindata(i).avgCI = filedata{8}(i);
%     obj.graindata(i).avgfit = filedata{9}(i);
%     obj.graindata(i).phaseID = int32(filedata{10}(i));
%     obj.graindata(i).npnts = int32(filedata{11}(i));
% 
% end

fclose(fid);

end