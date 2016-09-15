function remove_artifacts(obj)

    gIDmat = obj.grainmap.gIDmat;

    for i=1:length(obj.clusters)

        currClust = obj.clusters{i};
        currClust.remove_cluster_artifacts(gIDmat);

    end

end  