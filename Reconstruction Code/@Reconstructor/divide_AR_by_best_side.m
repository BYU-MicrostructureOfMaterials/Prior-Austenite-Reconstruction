function divide_AR_by_best_side(obj,clusterA,clusterB)
    
    gIDmat = obj.grainmap.gIDmat;
    
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
        toMove = ismember([clusterA.includedNonMemberGrains.OIMgid],overlapIDs);
        clusterA.inactiveGrains = [clusterA.inactiveGrains clusterA.includedNonMemberGrains(toMove)];
        clusterA.includedNonMemberGrains = clusterA.includedNonMemberGrains(~toMove);
    
        %Remove grains from member grains list, along with their PA
        %orientatons
        toMove = ismember([clusterA.memberGrains.OIMgid],overlapIDs);
        clusterA.inactiveGrains = [clusterA.inactiveGrains clusterA.memberGrains(toMove)];
        clusterA.parentPhaseOrientations = clusterA.parentPhaseOrientations(~toMove);
        clusterA.memberGrains = clusterA.memberGrains(~toMove);
        
    else %Then keep grains in cluster A, remove from B
        
        %Remove grains from included non-member grain list
        toMove = ismember([clusterB.includedNonMemberGrains.OIMgid],overlapIDs);
        clusterB.inactiveGrains = [clusterB.inactiveGrains clusterB.includedNonMemberGrains(toMove)];
        clusterB.includedNonMemberGrains = clusterB.includedNonMemberGrains(~toMove);
        
        %Remove grains from member grains list, along with their PA
        %orientatons
        toMove = ismember([clusterB.memberGrains.OIMgid],overlapIDs);
        clusterB.inactiveGrains = [clusterB.inactiveGrains clusterB.memberGrains(toMove)];
        clusterB.parentPhaseOrientations = clusterB.parentPhaseOrientations(~toMove);
        clusterB.memberGrains = clusterB.memberGrains(~toMove);
        
    end
    
    clusterA.calc_metadata(gIDmat,'filled');
    clusterB.calc_metadata(gIDmat,'filled');

end