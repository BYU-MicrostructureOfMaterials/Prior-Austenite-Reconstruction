%Fast reading of OIM Grain files of any size. 
%Jay Basinger March 31,2011
 
function [GrainFileVals FileName FilePath ] = ReadGrainFile(FilePath,FileName)
%Used for OIM .txt Grain files of the first type (based on OIM Analysis 6
%and earlier)

%Either leave the input blank, and a text dialog box will appear, or
%if the file and pathname are known, pass those in.

if nargin == 1
    GrainFilePath = FilePath;
elseif nargin == 2
    GrainFilePath = [FilePath FileName];
else
    [FileName, FilePath] = uigetfile('*.txt','grain file');
    GrainFilePath = [FilePath FileName];
end

disp('Reading in the grain file . . . ')

fid = fopen(GrainFilePath);
data = GetFileData(GrainFilePath,'#');

tline = '#';
while ~feof(fid)
    if strcmp(tline(1),'#') == 1
        
        tline = fgetl(fid);       
        
    else
        
        position = ftell(fid);
        status = fseek(fid, -length(tline)-2, 'cof');
        if status == -1
           errordlg('Error reading grainfile','Error')
           return;
        end
        GrainFileVals = textscan(fid, data.format);
        
    end
end

fclose(fid);