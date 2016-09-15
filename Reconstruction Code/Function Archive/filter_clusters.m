%Filter through clusters, removing redundant clusters
%Removal condition: any overlap, with PA orientations within
%window of each other

function filter_clusters(obj,redundantMisoTol,specialMisoTol)

    clusterSet = obj.clusters;

                        %%%%%%%%%%%%%%%%%%%%%%%
                        %Remove copy clusters %
                        %%%%%%%%%%%%%%%%%%%%%%%
                        
    clusterCenters = [clusterSet.clusterOCenter];
    clusterCentersQ = [clusterCenters.quat];
                        
    %Cycle through clusters, removing subsequent redundant/copy clusters
    nClust = length(clusterSet);
    currInd = 1;
    while currInd<nClust %any clusters left to check
        
        %Get current cluster data
        currClust = clusterSet(currInd);
        currClustMembers = [currClust.memberGrains.OIMgid];
        currLocs = currClust.scanLocations;
        currClustQ = clusterCentersQ(:,currInd);

        %Check clusters lower on list for overlap
        overlap = false(nClust,1);
        for i=currInd+1:nClust
            compClust = clusterSet(i);
            compLocs = compClust.scanLocations;
            overlap(i) = any(any(and(compLocs,currLocs)));
%             overlap(i) = sum(sum(and(currLocs,compLocs)))/sum(sum(compLocs))>.5;
        end
        
        %Check clusters on list for similar orientations
        inwindow = q_min_distfun(currClustQ',clusterCentersQ','cubic')<redundantMisoTol;
        
        toRemove = and(overlap,inwindow); %Only clusters lower in list should have possibility of being marked for removal
        
        %Merge uncommon members of clusters to be removed into the larger
        %cluster
%         clustToMerge = clusterSet(toRemove);
%         for i=clustToMerge
%             memberIDsToMerge = setdiff([i.memberGrains.OIMgid],currClustMembers);
%             currClust.includedNonMemberGrains = union(currClust.includedNonMemberGrains,obj.daughterGrains(ismember([obj.daughterGrains.OIMgid],memberIDsToMerge)));
%         end
        
        %!!!!!!!!!!!!!!!!!!!RECENTER MERGED CLUSTERS: RECALC CLUSTEROCENTER
        
        
        
        %Remove redundant clusters from list
        clusterSet = clusterSet(~toRemove);
        clusterCentersQ = clusterCentersQ(:,~toRemove);

        currInd = currInd + 1;
        nClust = length(clusterSet); 
    end
    
                        %%%%%%%%%%%%%%%%%%%%%%%%%%
                        %Remove special clusters %
                        %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Cycle through clusters, setting aside smaller clusters that may have a
    %special relationship with larger cluster (high degree of overlap with
    %a close to parallel close-packed plane)
    gammaPlanes = [1 1 1; -1 1 1; 1 -1 1; 1 1 -1]'/sqrt(3);
    nClust = length(clusterSet);
    currInd = 1;
    while currInd<nClust %any clusters left to check
        
        %Get current cluster data
        currClust = clusterSet(currInd);
        currLocs = currClust.scanLocations;
        currClustCPP = currClust.clusterOCenter.g'*gammaPlanes;
        
        %Check clusters lower on list for overlap
        overlap = false(nClust,1);
        for i=currInd+1:nClust
            compClust = clusterSet(i);
            compLocs = compClust.scanLocations;
            overlap(i) = sum(sum(and(currLocs,compLocs)))/sum(sum(compLocs))>.2;
        end
        
        %Check clusters for parallel close packed planes
        prllCPP = false(nClust,1);
        for i=currInd+1:nClust
            compClustCPP = clusterSet(i).clusterOCenter.g'*gammaPlanes;
            dotProducts = compClustCPP'*currClustCPP;
            angles = acos(dotProducts);
            toShift = angles>(pi/2);
            angles(toShift) = pi-angles(toShift);
            prllCPP(i) = min(min(angles))<specialMisoTol;
        end
        
        toRemove = and(overlap,prllCPP);
        
        %Move clusters to be removed into special clusters list
%         obj.specialClusters = union(obj.specialClusters,clusterSet(toRemove));
        clusterSet = clusterSet(~toRemove);
        
        currInd = currInd + 1;
        nClust = length(clusterSet);
    end
                        
    %Cycle through each cluster, including in list only if there is no overlap
    %with a previously included cluster
    includedClusters = clusterSet(1);
    coveredArea = clusterSet(1).scanLocations;

    for i=2:numel(clusterSet)

       currClust = clusterSet(i);
       currLocs = currClust.scanLocations;

       if ~any(any(and(currLocs,coveredArea)))
           includedClusters = [includedClusters currClust];
           coveredArea = or(coveredArea,currLocs);
       end

    end
    
    excludedClusters = setdiff(clusterSet,includedClusters);
    
    obj.clusters = clusterSet;
    obj.filteredClusters = includedClusters;
%     obj.temp = excludedClusters;
    
    
%     %Sort excluded clusters
%     for i=1:length(obj.temp)
%         currClust = obj.temp(i);
%         numVars(i) = sum(currClust.existingVariants);
%         numMembers(i) = length(currClust.memberGrains);
%     end
%     mat = [numVars(:) numMembers(:)];
%     [B,I] = sortrows(mat,[-1 -2]);
%     obj.temp = obj.temp(I);
    
end