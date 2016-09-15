gIDmat = testgrainmap.gIDmat;

clusterA = testreconstructor.clusters([testreconstructor.clusters.ID]==118);
clusterB = testreconstructor.clusters([testreconstructor.clusters.ID]==99);

clusterA.expand_cluster_by_NN(testreconstructor);
clusterB.expand_cluster_by_NN(testreconstructor);
clusterA.fill_cluster(testgrainmap);
clusterB.fill_cluster(testgrainmap);

clusterAset = [[clusterA.memberGrains] [clusterA.includedNonMemberGrains]];
clusterBset = [[clusterB.memberGrains] [clusterB.includedNonMemberGrains]];

clusterAsetIDs = [clusterAset.OIMgid];
clusterBsetIDs = [clusterBset.OIMgid];

commonRegionLocs = and(clusterA.scanLocations,clusterB.scanLocations);
commonRegion_IDs = unique(gIDmat(commonRegionLocs));


intersectByGrains = intersect(clusterAset,clusterBset);
intersectByGrainIDs = intersect(clusterAsetIDs,clusterBsetIDs);

problemGrainIDs = setdiff(intersectByGrainIDs,[intersectByGrains.OIMgid]);
problemGrains = testgrainmap.grains(ismember([testgrainmap.grains.OIMgid],problemGrainIDs));