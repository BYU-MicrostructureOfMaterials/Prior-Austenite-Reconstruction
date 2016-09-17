function fill_cluster(obj,grainmap)
    
    %Truncate image to region just around cluster
    [nrows,ncols] = size(obj.scanLocations);
    [locrows,loccols] = find(obj.scanLocations);

    minrow = min(locrows);
    mincol = min(loccols);
    maxrow = max(locrows);
    maxcol = max(loccols);

    if minrow>1, minrow = minrow - 1; end
    if maxrow<nrows, maxrow = maxrow + 1; end
    if mincol>1, mincol = mincol - 1; end
    if maxcol<ncols, maxcol = maxcol + 1; end
    
    gIDmat = grainmap.gIDmat(minrow:maxrow,mincol:maxcol);
    clusterBW = obj.scanLocations(minrow:maxrow,mincol:maxcol);
    
    filledLocs = region_fill_holes(clusterBW,4);
    
    interiorGrainIDs = unique(gIDmat(and(filledLocs,~clusterBW)));
    obj.includedNonMemberGrains = [obj.includedNonMemberGrains grainmap.grains(ismember([grainmap.grains.OIMgid],interiorGrainIDs))];
    obj.calc_metadata(grainmap.gIDmat,'filled',true);

end