function expand_cluster_by_NN(obj,reconstructor,includedPoolIDS)
    
    if nargin==3
        grainPool = reconstructor.daughterGrains(ismember([reconstructor.daughterGrains.OIMgid],includedPoolIDS));
        poolIDs = [grainPool.OIMgid];
    else
        grainPool = reconstructor.daughterGrains;
        poolIDs = [grainPool.OIMgid];
    end
    
    clustPAorientations = [obj.parentPhaseOrientations];
    clustPAquats = [clustPAorientations.quat];
    
    toAllocate = Grain.empty; %List of unallocated grains to add to included non-member list
    toAllocPAquats = [];
    clustChanged = true;
    while clustChanged
        
        clustChanged = false;

        %Get neighbor grains to both current set of cluster members and set
        %of unallocated grains to be allocated later
        neighborsToCheck = unique([[obj.memberGrains.neighborIDs] [obj.includedNonMemberGrains.neighborIDs] [toAllocate.neighborIDs]]);
        alreadyIncludedIDs = [[obj.memberGrains.OIMgid] [obj.includedNonMemberGrains.OIMgid] [toAllocate.OIMgid]];
        unAllocNeighborIDs = intersect(setdiff(neighborsToCheck,alreadyIncludedIDs),[grainPool.OIMgid]);
        unAllocNeighborGrains = grainPool(ismember(poolIDs,unAllocNeighborIDs)); 
        
        for currUnAllocNeighbor=unAllocNeighborGrains %For each neighbor check if it satisfies OR with any neighboring member of the cluster, or any neighboring grain marked to allocate to cluster later
            
            currUnAllocNeighborPAO = [currUnAllocNeighbor.newPhaseOrientations];
            currUnAllocNeighborPAQ = [currUnAllocNeighborPAO.quat];
            
            neighboringMemberIDs = intersect(currUnAllocNeighbor.neighborIDs,[obj.memberGrains.OIMgid]);
            neighboringToAllocateIDs = intersect(currUnAllocNeighbor.neighborIDs,[toAllocate.OIMgid]);
            
            neighboringMemberPAquats = clustPAquats(:,ismember([obj.memberGrains.OIMgid],neighboringMemberIDs));
            neighboringToAllocatePAquats = toAllocPAquats(:,ismember([toAllocate.OIMgid],neighboringToAllocateIDs));
            
            neighboringQuats = [neighboringMemberPAquats neighboringToAllocatePAquats];
            
            %If current unallocated grain has PA orientation in tolerance
            %of any neighboring cluster member or neighboring unallocated
            %grain already marked for acceptance, then add to list of
            %grains to be allocated
            
            for i=1:length(currUnAllocNeighborPAQ(1,:))
                
                misos = q_min_distfun(currUnAllocNeighborPAQ(:,i)',neighboringQuats','cubic');
                
                if any(misos<obj.misoTolerance)
                    
                    clustChanged = true;
                    toAllocate = [toAllocate currUnAllocNeighbor];
                    toAllocPAquats = [toAllocPAquats currUnAllocNeighborPAQ(:,i)];
                    
                    break
                end
                
            end
            
        end
        
    end
    
    %Add grains to allocate into included non-member list of cluster
    obj.includedNonMemberGrains = [obj.includedNonMemberGrains toAllocate];
    
end