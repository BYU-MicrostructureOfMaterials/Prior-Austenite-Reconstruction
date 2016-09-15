function [] = import_scandata(obj,scandata)
            
    %Input values for grain type and OR in phase key
    scankey = scandata.phasekey;
    varnames = scankey.Properties.VariableNames;
    [r,c] = size(scankey);
    if c~=2, error('Error reading in phasekey from scandata'); end

    colnames = {varnames{1} varnames{2} 'Grain Type' 'OR'};
    colformat = {'numeric','char',{'none' 'daughter' 'parent'},{'KS' 'NW' 'none'}};

    data = cell(r,4);
    for i=1:r
        data{i,1} = scandata.phasekey{i,1};
        data{i,2} = char(scandata.phasekey{i,2});
        data{i,3} = '';
        data{i,4} = '';
    end

    uit = uitable('Data', data,... 
                  'ColumnName', colnames,...
                  'ColumnFormat', colformat,...
                  'ColumnEditable', [false false true true],...
                  'RowName',[]);


    uit.CellEditCallback = {@callbackfunc,obj};
    waitfor(gcf);
    
    %Read in grains from scandata
    key = obj.phasekey;
    
    graindata = scandata.graindata;
    pointdata = scandata.pointdata;
    
    [r,c] = size(graindata);
    OIMgid = cell(r,1);%int32(zeros(r,1));
    phaseID = cell(r,1);%int32(zeros(r,1));
    grains = cell(r,1);
    for i=1:r
        
        %Extract data for current grain in list
        phaseID{i} = graindata.phaseID(i);
        OIMgid{i} = graindata.OIMgid(i);
        
        phi1 = graindata.avgphi1(i);
        PHI = graindata.avgPHI(i);
        phi2 = graindata.avgphi2(i);
        O = Orientation([phi1 PHI phi2],'euler');
        
        keyrow = key.phaseID==phaseID{i};
        if sum(keyrow)~=1, error('Non-unique phase identifier in phasekey'); end
        ind = find(keyrow);
        
        phasename = char(key{ind,2});
        graintype = char(key{ind,3});
        OR = char(key{ind,4});
        
        %Extract point data for current grain
        pointrows = pointdata.OIMgid==OIMgid{i};
        pointtable = pointdata(pointrows,:);
        
        %Create grain
        switch graintype
            case 'none'
                grains{i} = Grain(OIMgid{i},O,phaseID{i},phasename,pointtable); 
            case 'daughter'
                grains{i} = DaughterGrain(OIMgid{i},O,phaseID{i},phasename,pointtable,OR);
            case 'parent'
                grains{i} = ParentGrain();
        end
        
    end
    
    %Add new grains to table
    cellarray = [OIMgid, phaseID, grains];
    t = cell2table(cellarray,'VariableNames',{'OIMgid' 'phaseID' 'grains'});
    obj.grains = t;
    
    obj.minx = scandata.minx;
    obj.miny = scandata.miny;
    obj.maxx = scandata.maxx;
    obj.maxy = scandata.maxy;
    obj.stepsize = scandata.stepsize;
            
            
end


function callbackfunc(src,eventdata,obj)

indices = eventdata.Indices;
src.Data{indices(1),indices(2)} = eventdata.NewData;

table = cell2table(src.Data,'VariableNames',{'phaseID','phasename','graintype','OR'});
obj.phasekey = table;

end