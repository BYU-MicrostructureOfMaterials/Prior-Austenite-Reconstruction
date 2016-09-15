function place_clusters(obj)

clusterArray = obj.clusters;

%Fill cluster interiors
for currClust=clusterArray
%     currClust.expand_cluster_by_NN(obj);
    currClust.fill_cluster(obj.grainmap);
    currClust.calc_metadata(obj.grainmap.gIDmat,'filled');
end

clusterIDmat = int32(zeros(size(obj.grainmap.gIDmat)));

%Initialize cluster containers for sorting
placedClusters = DaughterCluster.empty;
filteredClusters = DaughterCluster.empty;
alternateOrientationClusters = DaughterCluster.empty;

for currClust=clusterArray
    
    %Test to see if current cluster overlaps with any previously placed
    %clusters
    overlap = and(currClust.scanLocations,clusterIDmat);
    if any(any(overlap))
        
        overlappingIDs = unique(clusterIDmat(overlap));
        
        while ~isempty(overlappingIDs)
        
            currID = overlappingIDs(1);
            compClust = placedClusters([placedClusters.ID]==currID);
            
            %Calculate data describing overlap
            currOverlapRatio = sum(sum(overlap))/sum(sum(currClust.scanLocations));
            compOverlapRatio = sum(sum(overlap))/sum(sum(compClust.scanLocations));
            PAmiso = q_min_distfun(currClust.clusterOCenter.quat',compClust.clusterOCenter.quat','cubic');
            
            %Determine nature of overlap
            overlapType = 'ambiguous'; %Default
            toPlace = false; %Default
            
            if ~any([currOverlapRatio compOverlapRatio] < obj.minRedundantOverlapRatio) %Both over
                if PAmiso<obj.redundantClusterMiso
                    overlapType = 'redundant';
                else
                    overlapType = 'alternateOrientation';
                end
            elseif any([currOverlapRatio compOverlapRatio] > obj.minRedundantOverlapRatio) %One over
                if PAmiso<obj.redundantClusterMiso
                    overlapType = 'redundant';
                else
                    if currOverlapRatio>obj.minInteriorOverlapRatio
                        overlapType = 'interior';
                    end
                end
            end
            
            %Resolve overlap either by removing cluster to appropriate
            %array, or by resolving overlap and placing in final
            %reconstruction
            switch overlapType
                case 'redundant'
                    filteredClusters = [filteredClusters currClust];
                    overlappingIDs = [];
                case 'interior'
                    filteredClusters = [filteredClusters currClust];
                    overlappingIDs = [];
                case 'alternateOrientation'
                    alternateOrientationClusters = [alternateOrientationClusters currClust];
                    %Something needs to be done to associate alternate
                    %orientation clusters with their placed cluster
                    overlappingIDs = [];
                case 'ambiguous'
                    disp('ambiguous');
%                     obj.divide_AR_by_best_side(currClust,compClust);
                    obj.divide_AR_by_SA(compClust,currClust);
                    toPlace = true;
                    overlappingIDs = setdiff(overlappingIDs,currID);
            end
            
        end
        
    else %No overlap, add cluster to placedClusters
        
        toPlace = true;
        
    end
    
    %If cluster is marked to place, move to placedClusters and add to
    %clusterIDmat, overwriting IDs where overlapping regions were assigned
    %to currClust
    if toPlace
        placedClusters = [placedClusters currClust];
        disp(length(placedClusters));
        clusterIDmat(currClust.scanLocations) = currClust.ID;
    end
 
end

obj.clusters = placedClusters;
obj.filteredClusters = filteredClusters;
obj.alternateOrientationClusters = alternateOrientationClusters;
obj.gen_cluster_IDmat;

end