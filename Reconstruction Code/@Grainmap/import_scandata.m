function [] = import_scandata(obj,scandata)
    
    %Read in grains from scandata
    key = scandata.phasekey;
    graindata = scandata.graindata;
    pointdata = scandata.pointdata;
    
    %Extract arrays used for grain definition
    phaseIDs = graindata.phaseID;
    OIMgids = graindata.OIMgid;
    avgphi1s = graindata.avgphi1;
    avgPHIs = graindata.avgPHI;
    avgphi2s = graindata.avgphi2;
    
    %Create grains
    for i=1:length(OIMgids);
        
        %Extract data for current grain in list
        phaseID = phaseIDs(i);
        OIMgid = OIMgids(i);
        
        phi1 = avgphi1s(i);
        PHI = avgPHIs(i);
        phi2 = avgphi2s(i);
        O = Orientation([phi1 PHI phi2],'euler');
        
        keyrow = key.phaseID==phaseID;
        phasename = char(key{keyrow,2});
        
        pointinds = pointdata.OIMgid==OIMgid;
        scanpoints = pointdata(pointinds,:);
        
        %Create grain
        grains(i) = Grain(OIMgid,O,phaseID,phasename,scanpoints); 
    end

    obj.grains = grains;
    
    obj.phasekey = key;
    obj.minx = scandata.minx;
    obj.miny = scandata.miny;
    obj.maxx = scandata.maxx;
    obj.maxy = scandata.maxy;
    obj.stepsize = scandata.stepsize;
                     
end