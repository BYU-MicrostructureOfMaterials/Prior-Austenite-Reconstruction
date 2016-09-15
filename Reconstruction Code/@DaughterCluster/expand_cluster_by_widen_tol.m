function expand_cluster_by_widen_tol(obj,reconstructor,newTol,includedPoolIDS)

    if nargin==4
        grainPool = reconstructor.daughterGrains(ismember([reconstructor.daughterGrains.OIMgid],includedPoolIDS));
        poolIDs = [grainPool.OIMgid];
    else
        grainPool = reconstructor.daughterGrains;
        poolIDs = [grainPool.OIMgid];
    end
    
    clusterPAQ = obj.clusterOCenter.quat;
    toAllocate = Grain.empty;

    clusterChanged = true;
    while clusterChanged
        
        clusterChanged = false;
        
        %Get neighbors to current cluster members, filtered down to IDs
        %that belong to current grain pool
        neighborsToCheck = unique([[obj.memberGrains.neighborIDs] [obj.includedNonMemberGrains.neighborIDs] [toAllocate.neighborIDs]]);
        alreadyIncludedIDs = [[obj.memberGrains.OIMgid] [obj.includedNonMemberGrains.OIMgid] [toAllocate.OIMgid]];
        unAllocNeighborIDs = neighborsToCheck(~ismember(neighborsToCheck,alreadyIncludedIDs));
        unAllocNeighborIDs = unAllocNeighborIDs(ismember(unAllocNeighborIDs,poolIDs));
        unAllocNeighborGrains = grainPool(ismember(poolIDs,unAllocNeighborIDs));
        
        %Check neighbors and add all within new tolerance to "toAllocate"
        for currNeighbor = unAllocNeighborGrains
            currNeighborPAO = [currNeighbor.newPhaseOrientations];
            currNeighborPAQ = [currNeighborPAO.quat];
            
            misos = q_min_distfun(clusterPAQ',currNeighborPAQ','cubic');
            
            if any(misos<newTol);
                toAllocate = [toAllocate currNeighbor];
                clusterChanged = true;
            end
            
        end
        
        
    end
    
    %Add grains to allocate into included non-member list of cluster
    obj.includedNonMemberGrains = [obj.includedNonMemberGrains(:)' toAllocate];

end