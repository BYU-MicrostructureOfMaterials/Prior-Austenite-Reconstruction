% clusterA = testreconstructor.clusters([testreconstructor.clusters.ID]==118);
% clusterB = testreconstructor.clusters([testreconstructor.clusters.ID]==99);
% clusterA.expand_cluster_by_NN(testreconstructor);
% clusterB.expand_cluster_by_NN(testreconstructor);
% clusterA.fill_cluster(testgrainmap);
% clusterB.fill_cluster(testgrainmap);
% clusterA.calc_metadata(testgrainmap.gIDmat,'filled');
% clusterB.calc_metadata(testgrainmap.gIDmat,'filled');

testreconstructor.divide_AR_by_SA(clusterA,clusterB);
compare_two_clusters(clusterA,clusterB,testgrainmap.gIDmat,'filled');