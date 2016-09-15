% testreconstructor.filter_clusters(12*pi/180,5*pi/180);

%Sort clusters by increasing size and number of variants
for i=1:length(testreconstructor.clusters)
%     numVars(i) = sum(testreconstructor.clusters(i).existingVariants);
%     numMembers(i) = length(testreconstructor.clusters(i).memberGrains);
    testreconstructor.clusters(i).fill_cluster(testgrainmap);
end
% mat = [numVars(:) numMembers(:)];
% [B,I] = sortrows(mat,[1 2]);
% testreconstructor.clusters = testreconstructor.clusters(I);

% testreconstructor.genReconstructedIPFmap('filled');

%Generate clusterIDmat and find all unallocated regions over a certain size
testreconstructor.gen_cluster_IDmat
covered = cellfun(@(x) ~isempty(x),testreconstructor.clusterIDmat);

unallocRegions = bwlabel(~covered,4);
regionIDs = setdiff(unique(unallocRegions),0);
for i=1:length(regionIDs)
    regionSizes(i) = sum(sum(unallocRegions==regionIDs(i)));
end

included = regionSizes>30;
regionIDs = regionIDs(included);
regionSizes = regionSizes(included);
unallocRegionsLocs =  ismember(unallocRegions,regionIDs);
nullGrainLocs = testgrainmap.phaseIDmat==1;

testgrainmap.phaseIDmat(and(unallocRegionsLocs,~nullGrainLocs)) = 7;
newreconstructor = Reconstructor(testgrainmap,'KS',[7]);
newreconstructor.tripletMinNeighborMiso = 1*pi/180;

newreconstructor.find_triplets;
newreconstructor.find_trios;
newreconstructor.grow_clusters_from_trios;
newreconstructor.filter_clusters(12*pi/180,5*pi/180);

maxClustID = max([testreconstructor.clusters.ID]);
for i=[newreconstructor.clusters]
    i.ID = i.ID + maxClustID;
end

combinedreconstructor = Reconstructor(testgrainmap);
combinedreconstructor.clusters = [[testreconstructor.clusters] [newreconstructor.clusters]];

%Sort new clusters by increasing size
for i=1:length(combinedreconstructor.clusters)
    numVars(i) = sum(combinedreconstructor.clusters(i).existingVariants);
    numMembers(i) = length(combinedreconstructor.clusters(i).memberGrains);
end
mat = [numVars(:) numMembers(:)];
[B,I] = sortrows(mat,[-2 -1]);
combinedreconstructor.clusters = combinedreconstructor.clusters(I);

% %Generate combined IPF map
% clusterSet1 = testreconstructor.clusters;
% clusterSet2 = newreconstructor.clusters;
% 
% Omap = containers.Map('KeyType','int32','ValueType','any');
% for i=clusterSet1
%     memberIDs = [[i.memberGrains.OIMgid] [i.includedNonMemberGrains.OIMgid]];
%     for j=1:length(memberIDs)
%         Omap(memberIDs(j)) = i.clusterOCenter;
%     end
% end
% for i=clusterSet2
%    memberIDs = [[i.memberGrains.OIMgid] [i.includedNonMemberGrains.OIMgid]];
%     for j=1:length(memberIDs)
%         Omap(memberIDs(j)) = i.clusterOCenter;
%     end
% end
% combinedIPF = IPFmap(testgrainmap.gIDmat,Omap);
% figure
% imshow(combinedIPF.IPFimage);

