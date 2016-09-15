% clusters = testreconstructor.clusters;
% clusters = clusterSet;
clusters = includedClusters;

figure(1);
hold on;

for i=1:length(clusters)
   currClust = clusters{i};
   currClust.clusterIPF(testgrainmap.gIDmat,'parentAverage','membersOnly');
   figure(1);
   disp(i);
   pause(1);
    
end
% 
% %%
% 
% %Test triplet finder
% 
% O(1) = Orientation([pi/6 pi/6 0],'euler');
% O(2) = Orientation([pi/6 pi/6 .21],'euler');
% O(3) = Orientation([pi/6 pi/6 .42],'euler');
% O(4) = Orientation([pi/6 pi/6 .63],'euler');
% 
% grainmap = Grainmap();
% 
% IDmat = zeros(20,20);
% IDmat(1:10,1:10) = 1;
% IDmat(1:10,11:20) = 2;
% IDmat(11:20,1:10) = 3;
% IDmat(11:20,11:20) = 4;
% 
% grainmap.gIDmat = IDmat;
% 
% for i=1:4
%     grains(i) = Grain(int32(i),O(i),int32(0),'testphase');
% end
% 
% grainmap.grains = grains;
% grainmap.find_neighbors;
% 
% reconstructor = Reconstructor(grainmap,'KS',0);
% reconstructor.find_triplets;
% 
% %%
% load quat_cubic_symops;
% testClust = testreconstructor.clusters(23);
% quats = [testClust.parentPhaseOrientations.quat];
% quats = quats(:,1:100);
% [cluster_miso_sum, rotated_quats, q_avg] = q_average_orientation(quats,quat_cubic_symops);
% 
% %%
% testClust = testreconstructor.clusters([3 7 12 20 21]);
% clustCenters = [testClust.clusterOCenter];
% quats = [clustCenters.quat];
% pole_figure_by_quat(quats(:,1)',[],[],'k.',1,1);
% 
% %%
% currClust = testreconstructor.clusters{16};
% probClust = testreconstructor.clusters{11};
% clustO = [currClust.memberGrains.orientation];
% currClustQuats = [clustO.quat];
% 
% gIDmat =  testgrainmap.gIDmat;
% 
% probGrainID = 509;
% probGrain = testgrainmap.grains(probGrainID);
% 
% probGrainQuat = probGrain.orientation.quat;
% probGrainPAQuats = [probGrain.newPhaseOrientations.quat];
% 
% pole_figure_by_quat(currClustQuats',[],[],'k.',1,3);
% pole_figure_by_quat(probGrainQuat',[],[],'bd',3,3);
% pole_figure_by_quat(probGrainPAQuats',[],[],'rd',3,3);
% 
% probPAmisos = q_min_distfun(currClust.clusterOCenter.quat',probGrainPAQuats','cubic');
% 
% min(probPAmisos)*(180/pi)
% 
% %%
% currClust = testreconstructor.clusters{16};
% gIDmat = testgrainmap.gIDmat;
% includedIDs = [[currClust.memberGrains.OIMgid] currClust.interiorNonMemberGrainIDs];
% clusterLocs = ismember(gIDmat,includedIDs);
% 
% pad_thk = 1;
% BW = bwperim(padarray(~clusterLocs,[pad_thk pad_thk],1));
% [r,c] = size(BW);
% BW = BW((pad_thk+1):(r-pad_thk), (pad_thk+1):(c-pad_thk)); %remove padding
% 
% BW2 = BW+clusterLocs;
% BW3 = imfill(BW2,'holes');
% filled = imfill(clusterLocs+(BW3-BW2),'holes');

%%

currClust = testreconstructor.clusters{14};
gIDmat = testgrainmap.gIDmat;
includedIDs = [[currClust.memberGrains.OIMgid] currClust.interiorNonMemberGrainIDs];
clusterLocs = ismember(gIDmat,includedIDs);


layeredCluster = clusterLocs;
[r,c] = size(clusterLocs);
for i=1:3
    inverseCluster = ~layeredCluster;
    inverseCluster = padarray(inverseCluster,[1 1],1);
    addLayer = bwperim(inverseCluster);
    addLayer = addLayer(2:r+1,2:c+1);
    layeredCluster = layeredCluster + addLayer;
    
    filledRegions(:,:,i) = imfill(layeredCluster,'holes')-layeredCluster;
    figure;
    imshow(filledRegions(:,:,i));

end



