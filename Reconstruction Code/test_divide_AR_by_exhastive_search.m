
% load reconstruction_9_6_16

clusterA = testreconstructor.clusters([testreconstructor.clusters.ID]==118);
clusterB = testreconstructor.clusters([testreconstructor.clusters.ID]==99);
clusterA.expand_cluster_by_NN(testreconstructor);
clusterB.expand_cluster_by_NN(testreconstructor);
clusterA.fill_cluster(testgrainmap);
clusterB.fill_cluster(testgrainmap);
clusterA.calc_metadata(testgrainmap.gIDmat,'filled');
clusterB.calc_metadata(testgrainmap.gIDmat,'filled');

testreconstructor.divide_AR_by_SA(clusterA,clusterB);
compare_two_clusters(clusterB,clusterA,testgrainmap.gIDmat,'filled');


%%

%plot grains in current overlapping region
currOverlap = ismember(obj.grainmap.gIDmat,[grainRegions{2}.OIMgid]);

IPFmap(:,:,1) = obj.grainmap.grainIPFmap.IPFimage(:,:,1).*currOverlap;
IPFmap(:,:,2) = obj.grainmap.grainIPFmap.IPFimage(:,:,2).*currOverlap;
IPFmap(:,:,3) = obj.grainmap.grainIPFmap.IPFimage(:,:,3).*currOverlap;

figure;
imshow(IPFmap);


%%

%Plot grains that are feasible for flipping to other region

IPFmap2(:,:,1) = parentReconstructor.grainmap.grainIPFmap.IPFimage(:,:,1).*ismember(fullgIDmat,feasibleGrainIDs);
IPFmap2(:,:,2) = parentReconstructor.grainmap.grainIPFmap.IPFimage(:,:,2).*ismember(fullgIDmat,feasibleGrainIDs);
IPFmap2(:,:,3) = parentReconstructor.grainmap.grainIPFmap.IPFimage(:,:,3).*ismember(fullgIDmat,feasibleGrainIDs);

figure;
imshow(IPFmap2);

%%

%plot individual grains from the set grainIDs or feasibleGrainIDs

ID = grainIDs(1);

IPFmap2(:,:,1) = parentReconstructor.grainmap.grainIPFmap.IPFimage(:,:,1).*double(fullgIDmat==ID);
IPFmap2(:,:,2) = parentReconstructor.grainmap.grainIPFmap.IPFimage(:,:,2).*double(fullgIDmat==ID);
IPFmap2(:,:,3) = parentReconstructor.grainmap.grainIPFmap.IPFimage(:,:,3).*double(fullgIDmat==ID);

figure;
imshow(IPFmap2);

%%

%plot overlap region and boundary region next to each other

mat = or(ismember(gIDmat,grainIDs),region);
mat = double(mat);
mat(ismember(gIDmat,grainIDs)) = 100;
mat(region) = 50;
figure;
imshow(mat2gray(mat));


mat = or(ismember(gIDmat,remainingGrainIDs),updatedRegion);
mat = double(mat);
mat(ismember(gIDmat,remainingGrainIDs)) = 100;
mat(updatedRegion) = 50;
figure;
imshow(mat2gray(mat));
