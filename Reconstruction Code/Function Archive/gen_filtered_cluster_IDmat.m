

%NEEDS TO BE UPDATED TO ACCOUNT FOR EACH CLUSTER HAVING ITS OWN LOGICAL
%MATRIX DESCRIBING THE SCANPOINTS IT COVERS


function gen_filtered_cluster_IDmat(obj)

    %Generate filtered clusterIDmat
    gIDmat = obj.grainmap.gIDmat;
    [r,c] = size(gIDmat);
    filteredClustermat = cell(r,c);

    %Cycle through each cluster and add cluster ID at each scan location it
    %covers
    for i=1:length(obj.filteredClusters)

        currClust = obj.filteredClusters(i);
        currClustID = currClust.ID;
        memberGrainIDs = [currClust.memberGrains.OIMgid];

        memberLocs = ismember(gIDmat,memberGrainIDs);

        filteredClustermat(memberLocs) = cellfun(@(x) [x currClustID], filteredClustermat(memberLocs),'UniformOutput',false);

    end

    obj.filteredClusterIDmat = filteredClustermat;

end