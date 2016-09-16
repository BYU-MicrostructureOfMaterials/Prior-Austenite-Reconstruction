function place_clusters(obj,clusters)

if nargin==1 %First placement of clusters, start from blank clusterIDmat
    clusterArray = obj.clusters;
    clusterIDmat = int32(zeros(size(obj.grainmap.gIDmat)));
elseif nargin==2 %Adding clusters to IPFmap, start from current clusterIDmat
    clusterArray = clusters;
    clusterIDmat = obj.clusterIDmat;
end

disp('Filling clusters');

%Fill all placed clusters then handle overlap
for currClust=obj.clusters
    currClust.fill_cluster(obj.grainmap);
end

%Initialize cluster containers for sorting
placedClusters = DaughterCluster.empty;
filteredClusters = DaughterCluster.empty;
alternateOrientationClusters = DaughterCluster.empty;

ambiguities = [];
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
            if strcmp(obj.OR,'KS')
                load KS_satellite_PA_orientations;
            elseif strcmp(obj.OR,'NW')
                load NW_satellite_PA_orientations;
            end
            
            for i=1:length(satellite_PA_orientations(1,:))
                satQ(:,i) = quatLmult(satellite_PA_orientations(:,i),compClust.clusterOCenter.quat);
            end
            
            currOverlapRatio = sum(sum(overlap))/sum(sum(currClust.scanLocations));
            compOverlapRatio = sum(sum(overlap))/sum(sum(compClust.scanLocations));
            PAmiso = q_min_distfun(currClust.clusterOCenter.quat',compClust.clusterOCenter.quat','cubic');
            satPAmiso = min(q_min_distfun(currClust.clusterOCenter.quat',satQ','cubic'));
            
            %Determine nature of overlap
            overlapType = 'ambiguous'; %Default
            toPlace = false; %Default
            
            if ~any([currOverlapRatio compOverlapRatio] < obj.criticalOverlapRatio) %Both over
                if PAmiso<compClust.misoTolerance 
                    overlapType = 'redundant';
                elseif satPAmiso<compClust.misoTolerance 
                    overlapType = 'alternateOrientation';
                end
            elseif currOverlapRatio > obj.criticalOverlapRatio %Current cluster is over
                if PAmiso<compClust.misoTolerance
                    overlapType = 'redundant';
                elseif satPAmiso<compClust.misoTolerance 
                    overlapType = 'interior';
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
                    compClust.alternateOrientationClusterIDs = [compClust.alternateOrientationClusterIDs currClust.ID];
                    %Something needs to be done to associate alternate
                    %orientation clusters with their placed cluster
                    overlappingIDs = [];
                case 'ambiguous'
                    ambiguities = [ambiguities; [compClust.ID currClust.ID]];
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
        clusterIDmat(currClust.scanLocations) = currClust.ID;
    end
 
end

obj.clusters = placedClusters;
obj.filteredClusters = filteredClusters;
obj.alternateOrientationClusters = alternateOrientationClusters;

disp(['Number of ambiguities: ',num2str(length(ambiguities(:,1)))]);
if ~isempty(ambiguities)
    for i=1:length(ambiguities(:,1))

        clusterA = obj.clusters([obj.clusters.ID]==ambiguities(i,1));
        clusterB = obj.clusters([obj.clusters.ID]==ambiguities(i,2));

        if ~isempty(clusterA) && ~isempty(clusterB)
            
            switch obj.ambiguityMethod
                case 'Simulated Annealing'
                    obj.divide_AR_by_SA(clusterA,clusterB);
                case 'Best side (fast)'
                    obj.divide_AR_by_best_side(clusterA,clusterB);
            end
            
            
        end
    end
end

obj.gen_cluster_IDmat;

disp('Done placing clusters');

end