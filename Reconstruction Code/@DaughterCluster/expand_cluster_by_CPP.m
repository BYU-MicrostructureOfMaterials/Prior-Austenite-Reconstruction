
function expand_cluster_by_CPP(obj,reconstructor,miso,includedPoolIDs)
    
    if nargin==4
        grainPool = reconstructor.daughterGrains(ismember([reconstructor.daughterGrains.OIMgid],includedPoolIDs));
        poolIDs = [grainPool.OIMgid];
    else
        grainPool = reconstructor.daughterGrains;
        poolIDs = [grainPool.OIMgid];
    end
    
    %Generate current cluster's CPP data
    clustPlanes = [1 1 1; -1 1 1; 1 -1 1; 1 1 -1]/sqrt(3);
    clustPlanes = obj.clusterOCenter.g'*clustPlanes';
    
    %Expand cluster
    neighborPlanes = [1 1 0; 1 0 1; 0 1 1; -1 1 0; -1 0 1; 0 -1 1]/sqrt(2);
    clustChanged = true;
    while clustChanged
        
        clustChanged = false;

        %Get neighbor grains to current set of cluster members
        clustNeighbors = unique([[obj.memberGrains.neighborIDs] [obj.includedNonMemberGrains.neighborIDs]]);
        clustMembers = [[obj.memberGrains.OIMgid] [obj.includedNonMemberGrains.OIMgid]];
        neighborIDs = intersect(setdiff(clustNeighbors,clustMembers),[grainPool.OIMgid]);
        neighborGrains = grainPool(ismember(poolIDs,neighborIDs)); 
        
        for currNeighbor=neighborGrains %for each neighbor check if it has a CPP within tol of cluster center
            
            currNeighPlanes = currNeighbor.orientation.g'*neighborPlanes';
                
            dotProducts = currNeighPlanes'*clustPlanes;
            angles = acos(dotProducts);
            toShift = angles>(pi/2);
            angles(toShift) = pi-angles(toShift);
            
            %If minimum angle relating CPPs is below tolerance, add to
            %cluster's included non-member grains
            minAngle = min(min(angles));
            
            if minAngle<miso
                obj.includedNonMemberGrains = [[obj.includedNonMemberGrains] currNeighbor];
                clustChanged = true;
            end
            
        end
        
    end

end