function handle_reconstruction_overlap(obj)

    obj.gen_cluster_IDmat;
    
    overlap = cellfun(@(x) numel(x),obj.clusterIDmat);
    locs = overlap==2;
    overlapCells = obj.clusterIDmat(locs);
    overlappingClusters = unique(cell2mat(overlapCells),'rows');
    
    for i=1:length(overlappingClusters(:,1))
        
        clusterAID = overlappingClusters(i,1);
        clusterBID = overlappingClusters(i,2);
        
        clusterA = obj.clusters([obj.clusters.ID]==clusterAID);
        clusterB = obj.clusters([obj.clusters.ID]==clusterBID);
        
        obj.split_cluster_overlap(clusterA,clusterB);
        
    end
    
    
end