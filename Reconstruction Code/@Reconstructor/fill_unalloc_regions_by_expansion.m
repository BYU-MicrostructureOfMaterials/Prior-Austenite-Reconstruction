function fill_unalloc_regions_by_expansion(obj,minsize)

disp('filling unallocated regions');

gIDmat = obj.grainmap.gIDmat;

%Get list of all unallocated regions over a certain size
unallocLocs = ~logical(obj.clusterIDmat);
unallocIDmat = region_label(unallocLocs,4);

numRegions = max(max(unallocIDmat));

regionSizes = zeros(1,numRegions);
for i=1:numRegions
    currRegion = unallocIDmat==i;
    regionSizes(i) = sum(sum(currRegion));
end

regionsToFill = find(regionSizes>minsize);

%Cycle through each region, expanding adjacent clusters by widening
%tolerances until unallocated region is consumed
misoIncrement = 2*pi/180;
for i=1:length(regionsToFill)
    
    currRegionID = regionsToFill(i);
    currRegion = unallocIDmat==currRegionID;
    grainIDsToAdd = unique(gIDmat(currRegion));
    grainIDsToAdd = grainIDsToAdd(ismember(grainIDsToAdd,[obj.daughterGrains.OIMgid]));
    
    %Find all clusters bordering current unallocated region
    regionShell = extract_boundary(currRegion);
    neighborClusterIDs = unique(obj.clusterIDmat(regionShell));
    neighborClusters = obj.clusters(ismember([obj.clusters.ID],neighborClusterIDs));
    neighborClusterMisoTols = [neighborClusters.misoTolerance];
    
    %Expand all neighboring clusters with widening toleranced until the
    %unallocated region is filled
    regionFilled = false;
    while ~regionFilled
        
        regionFilled = true;
        
        %For each neighboring cluster, increment the tolerance and expand
        %the cluster
        allocatedIDs = [];
        neighborClusterMisoTols = neighborClusterMisoTols + misoIncrement;
        for j=1:length(neighborClusters)
            currNeighbor = neighborClusters(j);
            currNeighbor.expand_cluster_by_widen_tol(obj,neighborClusterMisoTols(j),grainIDsToAdd);
            allocatedIDs = unique([allocatedIDs [currNeighbor.memberGrains.OIMgid] [currNeighbor.includedNonMemberGrains.OIMgid]]);
        end
        
        %Check to see if the unallocated region is now filled
        grainIDsToAdd = grainIDsToAdd(~ismember(grainIDsToAdd,allocatedIDs));
        if ~isempty(grainIDsToAdd)
            regionFilled = false;
        end
        
    end
        
    %Region is filled, run calc_metadata for each cluster and move to next
    %unallocated region
    for currNeighbor = neighborClusters;
        currNeighbor.calc_metadata(gIDmat,'filled');
    end
    
end

obj.gen_cluster_IDmat;

%Cycle through all clusters to fix any new cases of overlap
% for currClust = obj.clusters;
%     overlappingIDs = unique(ismember(obj.clusterIDmat,currClust.scanLocations));
%     
%     for 
%     
% end

end