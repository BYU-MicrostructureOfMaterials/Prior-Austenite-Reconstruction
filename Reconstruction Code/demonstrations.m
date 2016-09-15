%Demonstrate cluster growth

trio = testreconstructor.clusters(2).startTrio;
clust = DaughterCluster(trio,'KS');
clust.grow_cluster(testreconstructor)

%%

%Select triplet points manually, reconstruct easy set
testreconstructor = Reconstructor(testgrainmap,'KS',[1]);
IDs = point_select_IPF_data(testgrainmap.grainIPFmap.IPFimage,testgrainmap.gIDmat);
testreconstructor.find_triplets(IDs);
