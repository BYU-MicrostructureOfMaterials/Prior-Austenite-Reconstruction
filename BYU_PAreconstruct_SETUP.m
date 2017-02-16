function BYU_PAreconstruct_SETUP

    %Hi Brett

    %Move files into new folder
    [pathstr,currFolder,~] = fileparts(cd);
    movefile(['../',currFolder],'../BYU_PAreconstruct_v_2016_10_11');
    cd '../BYU_PAreconstruct_v_2016_10_11';
    rmdir(['../',currFolder]);
    
    %Check if a past version of "BYU_PAreconstruct.m" is in the path
    %variable. If so, remove it.
    pathCell = regexp(path,pathsep,'split');
    versionOnPath =cellfun(@(x) any(x), strfind(pathCell,'BYU_PAreconstruct_v_'));
    versionPath = pathCell(versionOnPath);
    
    if ~isempty(versionPath)
       for i=1:length(versionPath)
           rmpath(versionPath{i});
       end
    end
    
    %Add current folder to path variable
    addpath(genpath(cd));
    savepath;
    

end