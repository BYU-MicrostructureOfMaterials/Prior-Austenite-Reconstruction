
function gen_cluster_IDmat(obj)

    %Generate cluster ID mat
    gIDmat = obj.grainmap.gIDmat;
    [r,c] = size(gIDmat);
    clustermat = zeros(r,c);

    %Cycle through each cluster and add cluster ID at each scan location it
    %covers
    for i=1:length(obj.clusters)

        currClust = obj.clusters(i);
        currClustID = currClust.ID;
        clustermat(currClust.scanLocations) = currClustID;

    end

    obj.clusterIDmat = int32(clustermat);
   
end