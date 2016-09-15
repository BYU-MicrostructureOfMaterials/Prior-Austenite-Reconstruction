%DO NOT RUN THIS AFTER RUNNING FILL_CLUSTER

%THIS CURRENT VERSION OF FUNCTION ONLY RUNS AFTER CLUSTERS HAVE ALL BEEN
%GROWN, AND ONLY CONSIDERS DAUGHTER GRAINS THAT HAVE NOT BEEN ALLOCATED TO
%A CLUSTER
function grow_cluster_by_CPP(obj,reconstructor,miso)

%     reconstructor.filter_clusters(12*pi/180,5*pi/180);
%     reconstructor.gen_cluster_IDmat

    gIDmat = reconstructor.grainmap.gIDmat;
    covered = cellfun(@(x) ~isempty(x),reconstructor.clusterIDmat);
    
    includedGrainIDs = [reconstructor.daughterGrains.OIMgid];
    includedArea = ismember(gIDmat,includedGrainIDs);
    
    grainIDpool = unique(gIDmat(and(~covered,includedArea)));
    grainPool = reconstructor.daughterGrains(grainIDpool);
    
    
    %Generate current cluster's CPP data
    clustPlanes = [1 1 1; -1 1 1; 1 -1 1; 1 1 -1]/sqrt(3);
    clustPlanes = obj.clusterOCenter.g'*clustPlanes';
    
    %Grow cluster
    neighborPlanes = [1 1 0; 1 0 1; 0 1 1; -1 1 0; -1 0 1; 0 -1 1]/sqrt(2);
    clustChanged = true;
    while clustChanged
        
        clustChanged = false;

        %Get neighbor grains to current set of cluster members
        clustNeighbors = unique([[obj.memberGrains.neighborIDs] [obj.includedNonMemberGrains.neighborIDs]]);
        clustMembers = [[obj.memberGrains.OIMgid] [obj.includedNonMemberGrains.OIMgid]];
        neighborIDs = intersect(setdiff(clustNeighbors,clustMembers),[grainPool.OIMgid]);
        neighborGrains = grainPool(ismember([grainPool.OIMgid],neighborIDs)); 
        
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