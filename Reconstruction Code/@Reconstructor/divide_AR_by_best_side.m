function divide_AR_by_best_side(obj,clusterA,clusterB)
    
    gIDmat = obj.grainmap.gIDmat;
    clusterA.fill_cluster(obj.grainmap);
    clusterB.fill_cluster(obj.grainmap);
    
    overlapRegion = and(clusterA.scanLocations,clusterB.scanLocations);
    overlapIDs = unique(gIDmat(overlapRegion));
    exclusiveA = and(clusterA.scanLocations,~clusterB.scanLocations);
    exclusiveB = and(clusterB.scanLocations,~clusterA.scanLocations);
    
    %test case of exclusive A with overlapping region allocated to B
    [Ashell,Bshell,boundary,BL_allocB] = extract_boundary(exclusiveA,clusterB.scanLocations);
    
    %Test case of exclusive B with overlapping region allocated to A
    [Ashell,Bshell,boundary,BL_allocA] = extract_boundary(exclusiveB,clusterA.scanLocations);
    
    if BL_allocB<BL_allocA %Then keep grains in cluster B, remove from A
        
        %Remove grains from included non-member grain list
        toMove = clusterA.includedNonMemberGrains(ismember([clusterA.includedNonMemberGrains.OIMgid],overlapIDs));
        clusterA.includedNonMemberGrains = setdiff(clusterA.includedNonMemberGrains,toMove);
        clusterA.inactiveGrains = union(clusterA.inactiveGrains,toMove);
        
        %Remove grains from member grains list, along with their PA
        %orientatons
        toMove = clusterA.memberGrains(ismember([clusterA.memberGrains.OIMgid],overlapIDs));
        clusterA.parentPhaseOrientations = clusterA.parentPhaseOrientations(~ismember([clusterA.memberGrains.OIMgid],overlapIDs));
        clusterA.memberGrains = setdiff(clusterA.memberGrains,toMove);
        clusterA.inactiveGrains = union(clusterA.inactiveGrains,toMove);
        
    else %Then keep grains in cluster A, remove from B
        
        %Remove grains from included non-member grain list
        toMove = clusterB.includedNonMemberGrains(ismember([clusterB.includedNonMemberGrains.OIMgid],overlapIDs));
        clusterB.includedNonMemberGrains = setdiff(clusterB.includedNonMemberGrains,toMove);
        clusterB.inactiveGrains = union(clusterB.inactiveGrains,toMove);
        
        %Remove grains from member grains list, along with their PA
        %orientatons
        toMove = clusterB.memberGrains(ismember([clusterB.memberGrains.OIMgid],overlapIDs));
        clusterB.parentPhaseOrientations = clusterB.parentPhaseOrientations(~ismember([clusterB.memberGrains.OIMgid],overlapIDs));
        clusterB.memberGrains = setdiff(clusterB.memberGrains,toMove);
        clusterB.inactiveGrains = union(clusterB.inactiveGrains,toMove);
        
    end

end