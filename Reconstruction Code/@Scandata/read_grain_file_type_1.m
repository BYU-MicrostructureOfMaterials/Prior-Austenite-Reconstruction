%Format of grainfile type 1 is enforced. Must be square grid and have 
%following rows in header:
% 
% # Column 1-3: phi1, PHI, phi2 (orientation of point in radians)
% # Column 4-5: x, y (coordinates of point in microns)
% # Column 6:   IQ (image quality)
% # Column 7:   CI (confidence index)
% # Column 8:   Fit (degrees)
% # Column 9:   Grain ID (integer)
% # Column 10:  edge (1 for grains at edges of scan and 0 for interior grains)
% # Column 11:  phase name

function [] = read_grain_file_type_1(obj,filename)

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

Xpos = filedata{4};
Ypos = filedata{5};

%%Use a while loop to find the next row and compare the initial x values of
%%the first 4 rows to see if it is a Hex or Square Scan

test1=0;
rowcount = 1;
while (test1==0)
    rowcount = rowcount + 1;
    test1 = Ypos(1,1) - Ypos(rowcount,1);
    
end

rowcount = rowcount;

test2=0;
rowcount2 = rowcount;

while (test2==0)
    rowcount2 = rowcount2 + 1;
    test2 = Ypos(rowcount,1) - Ypos(rowcount2,1);
    
end

test3=0;
rowcount3 = rowcount2;

while (test3==0)
    rowcount3 = rowcount3 + 1;
    test3 = Ypos(rowcount2,1) - Ypos(rowcount3,1);
    
end

%Minus the first 4 values of the of each row in the scan (what if just one
%scan point is missing?)

issquare = Xpos(1,1)-Xpos((rowcount),1)-Xpos((rowcount2),1)-Xpos((rowcount3),1);

if issquare ~= 0 
    error('Input grain file must be of square scan. Convert to square scan first.'); end

%Check column data format. Must have following lines:
format{1} = '# Column 1-3: phi1, PHI, phi2 (orientation of point in radians)';
format{2} = '# Column 4-5: x, y (coordinates of point in microns)';
format{3} = '# Column 6:   IQ (image quality)';
format{4} = '# Column 7:   CI (confidence index)';
format{5} = '# Column 8:   Fit (degrees)';
format{6} = '# Column 9:   Grain ID (integer)';
format{7} = '# Column 10:  edge (1 for grains at edges of scan and 0 for interior grains)';
format{8} = '# Column 11:  phase name';

formatcheck = ismember(format,header);
if any(formatcheck==0), error('Incorrect format. Check grain file header and verify that required rows match expected format.'); end


%Read in file data
filedata = ReadGrainFile(filename);
numcol = length(filedata);

%If there are columns for phase name, concatenate strings
if numcol>11
    
    phase = cell(length(filedata{1}),1);
    spaces =  cell(length(filedata{1}),1);
    for i=1:length(filedata{1})
        spaces{i} = ' ';
    end

    for j=11:numcol
        phase = strcat(phase,spaces,filedata{j});
    end

else
    phase = filedata{11};
end

phi1 = filedata{1};
PHI = filedata{2};
phi2 = filedata{3};
x = filedata{4};
y = filedata{5};
IQ = filedata{6};
CI = filedata{7};
fit = filedata{8};
OIMgid = int32(filedata{9});
edge = logical(filedata{10});

obj.pointdata = table(phi1,PHI,phi2,x,y,IQ,CI,fit,OIMgid,edge,phase);


% for i=1:length(filedata{1})
% 
%     obj.pointdata(i).phi1 = filedata{1}(i);
%     obj.pointdata(i).PHI = filedata{2}(i);
%     obj.pointdata(i).phi2 = filedata{3}(i);
%     obj.pointdata(i).x = filedata{4}(i);
%     obj.pointdata(i).y = filedata{5}(i);
%     obj.pointdata(i).IQ = filedata{6}(i);
%     obj.pointdata(i).CI = filedata{7}(i);
%     obj.pointdata(i).fit = filedata{8}(i);
%     obj.pointdata(i).OIMgid = int32(filedata{9}(i));
%     obj.pointdata(i).edge = logical(filedata{10}(i));
%     obj.pointdata(i).phase = filedata{11}(i);
% 
% end

fclose(fid);

end