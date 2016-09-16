function genReconstructedIPFmap(obj,filledtype)

    emptymap = containers.Map;
    reconstructedIPFmap = IPFmap(obj.grainmap.gIDmat,emptymap);

    for i=1:length(obj.clusters)

        currCluster = obj.clusters(i);

        switch filledtype
            case 'membersOnly'
                IDs = [currCluster.memberGrains.OIMgid];
            case 'filled'
                IDs = [[currCluster.memberGrains.OIMgid] [currCluster.includedNonMemberGrains.OIMgid]];
        end

        Omap = containers.Map('KeyType','int32','ValueType','any');
        for j=1:length(IDs)
            Omap(IDs(j)) = currCluster.clusterOCenter;
        end

        reconstructedIPFmap.add_data(Omap);
        disp([i length(obj.clusters)]);
    end

    obj.reconstructedIPFmap = reconstructedIPFmap;
    

end