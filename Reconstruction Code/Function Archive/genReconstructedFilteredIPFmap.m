function genReconstructedFilteredIPFmap(obj,filledtype)

    emptymap = containers.Map;
    reconstructedFilteredIPFmap = IPFmap(obj.grainmap.gIDmat,emptymap);

    for i=1:length(obj.filteredClusters)

        currCluster = obj.filteredClusters(i);

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

        reconstructedFilteredIPFmap.add_data(Omap);
        disp([i length(obj.filteredClusters)]);
    end

    obj.reconstructedFilteredIPFmap = reconstructedFilteredIPFmap;
    
    figure;
    imshow(reconstructedFilteredIPFmap.IPFimage);
    

end