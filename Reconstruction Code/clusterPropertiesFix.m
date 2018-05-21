function clusterPropertiesFix(reconstructor)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:length(reconstructor.clusters)
%         reconstructor.clusters(1).calc_metadata(reconstructor.grainmap.gIDmat,'filled',1)
        if (size(reconstructor.clusters(i).memberGrains,1) > size(reconstructor.clusters(i).memberGrains,2))
            reconstructor.clusters(i).memberGrains = reconstructor.clusters(i).memberGrains';
        end
        if (size(reconstructor.clusters(i).includedNonMemberGrains,1) > size(reconstructor.clusters(i).includedNonMemberGrains,2))
            reconstructor.clusters(i).includedNonMemberGrains = reconstructor.clusters(i).includedNonMemberGrains';
        end
        if (size(reconstructor.clusters(i).inactiveGrains,1) > size(reconstructor.clusters(i).inactiveGrains,2))
            reconstructor.clusters(i).inactiveGrains = reconstructor.clusters(i).inactiveGrains';
        end
    end
end

