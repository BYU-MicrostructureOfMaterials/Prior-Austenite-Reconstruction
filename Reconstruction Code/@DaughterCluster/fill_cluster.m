function fill_cluster(obj,grainmap)
    
    filledLocs = imfill(obj.scanLocations,4,'holes');
    interiorGrainIDs = unique(grainmap.gIDmat(and(filledLocs,~obj.scanLocations)));
    obj.includedNonMemberGrains = union(obj.includedNonMemberGrains,grainmap.grains(ismember([grainmap.grains.OIMgid],interiorGrainIDs)));
    obj.calc_metadata(grainmap.gIDmat,'filled');

end