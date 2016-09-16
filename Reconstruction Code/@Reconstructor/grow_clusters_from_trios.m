function grow_clusters_from_trios(obj)

    disp('Growing clusters from trios');

    clustOR = obj.OR;
    misoTol = obj.clusterMisoTol;

    trioArray = obj.trios;
    trioGrainIDs = [trioArray.tripletGrainIDs]';
    trioAvgO = [trioArray.avgOrientation];
    trioAvgQ = [trioAvgO.quat];

    clusterCount = 1;
    while ~isempty(trioArray);

        %Grow cluster
        currClust = DaughterCluster(trioArray(1),clustOR,misoTol);
        currClust.grow_cluster(obj);
        clusterArray(clusterCount) = currClust;
        clusterCount = clusterCount + 1;
        
        %Find all trios with overlapping members to current cluster
        overlap = ismember(trioGrainIDs,[[currClust.memberGrains.OIMgid] [currClust.includedNonMemberGrains.OIMgid]]);
        overlap = any(overlap,2);
        
        %Find all trios with averaged orientations close to cluster's
        inWindow = q_min_distfun(currClust.clusterOCenter.quat',trioAvgQ','cubic')<currClust.misoTolerance;
        
        toRemove = and(overlap,inWindow);
        toRemove(1) = true;
        
        trioArray = trioArray(~toRemove);
        trioGrainIDs = trioGrainIDs(~toRemove,:);
        trioAvgQ = trioAvgQ(:,~toRemove);

    end
    
    %Assign cluster ID numbers and gather cluster information for sorting
    numVars = zeros(1,length(clusterArray));
    numMembers = zeros(1,length(clusterArray));
    for i=1:length(clusterArray)
        currClust = clusterArray(i);
        currClust.setClusterID(int32(i));
        currClust.calc_metadata(obj.grainmap.gIDmat,'filled');
        numVars(i) = sum(currClust.existingVariants);
        numMembers(i) = length(currClust.memberGrains);
    end

    %Sort clusters by decreasing number of variants present, then
    %by decreasing size
    mat = [numVars(:) numMembers(:)];
    [B,I] = sortrows(mat,[-1 -2]);
    clusterArray = clusterArray(I);
    
    obj.clusters = clusterArray;

    disp(['Done growing clusters: ', num2str(length(obj.clusters)), ' grown']);

end