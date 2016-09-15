function gen_IDmats(obj)

    [ncols,nrows] = obj.pixel_loc(obj.maxx,obj.maxy,obj.minx,obj.miny,obj.stepsize);
    grmat = zeros(nrows,ncols);
    pmat = zeros(nrows,ncols);

    gIDs = [obj.grains.OIMgid];
    pIDs = [obj.grains.phaseID];

    for i=1:length(gIDs)

        currgrain = obj.grains(gIDs==gIDs(i));
        X = currgrain.scanpoints.x;
        Y = currgrain.scanpoints.y;

        [pixelcols,pixelrows] = obj.pixel_loc(X,Y,obj.minx,obj.miny,obj.stepsize);

        for j=1:length(pixelcols)
            grmat(pixelrows(j),pixelcols(j)) = gIDs(i);
            pmat(pixelrows(j),pixelcols(j)) = pIDs(i);
        end

    end

    %Fill 0 values in gmat with unique IDs
    maxGID = max(gIDs);
    maxPID = max(pIDs);
    emptyScanpoints = ~grmat;
    hold = int32(bwlabel(emptyScanpoints));
    hold(emptyScanpoints) = hold(emptyScanpoints)+maxGID;
    grmat = int32(grmat) + hold;
    pmat(emptyScanpoints) = maxPID + 1;

    %For each new ID create a null grain with only an ID
    newGrainIDs = setdiff(unique(hold),0);
    
    if ~isempty(newGrainIDs)
        for i=1:length(newGrainIDs)
            nullGrains(i) = Grain(newGrainIDs(i));
        end

        obj.grains = [obj.grains nullGrains];
    end
    
    %Create IQ and CI matrices
    xdata = obj.scandata.pointdata.x;
    ydata = obj.scandata.pointdata.y;
    IQdata = obj.scandata.pointdata.IQ;
    CIdata = obj.scandata.pointdata.CI;

    [c,r] = Grainmap.pixel_loc(xdata,ydata,obj.minx,obj.miny,obj.stepsize);

    IQmat = zeros(nrows,ncols);
    CImat = zeros(nrows,ncols);
    for i=1:length(c)
        IQmat(r(i),c(i)) = IQdata(i);
        CImat(r(i),c(i)) = CIdata(i);
    end

    IQmat = IQmat/max(max(IQmat));
    CImat = CImat/max(max(IQmat));
    
    obj.IQmat = IQmat;
    obj.CImat = CImat;
    
    
    obj.gIDmat = grmat;
    obj.phaseIDmat = int32(pmat);
    obj.datalocked = true;

end