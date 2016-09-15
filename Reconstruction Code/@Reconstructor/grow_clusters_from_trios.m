function grow_clusters_from_trios(obj)

    clustOR = obj.OR;

    trioArray = obj.trios;
    
    clusterArray = cell(1,length(trioArray));
    for i=1:length(trioArray)

        currClust = DaughterCluster(trioArray(i),clustOR,obj.misotolerance);
        
        currClust.grow_cluster(obj);
        
        clusterArray{i} = currClust;

    end
    
    %Assign cluster ID numbers
    for i=1:length(clusterArray)
        currClust = clusterArray{i};
        currClust.setClusterID(int32(i));
    end

    %Sort clusters by decreasing number of variants present, then
    %by decreasing size
    numVars = cellfun(@(x) sum(x.existingVariants),clusterArray);
    numMembers = cellfun(@(x) length(x.memberGrains),clusterArray);
    mat = [numVars(:) numMembers(:)];
    [B,I] = sortrows(mat,[-1 -2]);
    clusterArray = clusterArray(I);

    %Run each cluster's calc_metadata function
    cellfun(@(x) x.calc_metadata(obj.grainmap.gIDmat,'filled'), clusterArray);
    
    obj.clusters = [clusterArray{:}];
    
%     obj.gen_cluster_IDmat;

    disp(['Done growing clusters: ', num2str(length(obj.clusters))]);

end