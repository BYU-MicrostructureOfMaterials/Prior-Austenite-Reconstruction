function fill_unalloc_regions(obj,minsize)

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


%Cycle through each region, run multiple functions to fill and handle new
%overlap

for i=1:length(regionsToFill)
    
    currRegionID = regionsToFill(i);
    currRegion = unallocIDmat==currRegionID;
    grainsToAdd = unique(gIDmat(currRegion));
    
    %Find all clusters bordering current unallocated region
    regionShell = extract_boundary(currRegion);
    neighborClusterIDs = unique(obj.clusterIDmat(regionShell));
    neighborClusters = obj.clusters(ismember([obj.clusters.ID],neighborClusterIDs));
    
    %Consume area by existing clusters------------------------------------
    if length(neighborClusterIDs)==1
        
        %Assign whole region to single neighboring cluster
        neighborClusters.includedNonMemberGrains = [neighborClusters.includedNonMemberGrains grainsToAdd];
        
    elseif length(neighborClusterIDs)==2
        
        %Assign whole region to both clusters, run simulated annealing to
        %divide
        clusterA = neighborClusters(1);
        clusterB = neighborClusters(2);
        
        clusterA.includedNonMemberGrains = [clusterA.includedNonMemberGrains grainsToAdd];
        clusterB.includedNonMemberGrains = [clusterB.includedNonMemberGrains grainsToAdd];
        
        obj.divide_AR_by_SA(clusterA,clusterB);
        
    elseif length(neighborClusterIDs)>2
        %Assign whole region to all clusters, run simulated annealing
        %between cluster that shares most of the region's boundary and the
        %cluster that shares the next most boundary. Then consider
        %subsequent neighboring clusters, handling individual cases of
        %overlap.
        
        
    end
    %---------------------------------------------------------------------
    
    %Grow new clusters---------------------------------------------------
    
    %--------------------------------------------------------------------
    
    
    
    %Decide if any new clusters will be kept, adding to placed clusters and
    %handling new overlap cases
    
end






end