
%run each cluster's calc_metadata function
clusterSet = testreconstructor.clusters;
parfor i=1:numel(clusterSet)
    
    currClust = clusterSet{i};
    currClust.calc_metadata;
    
    clusterSet{i} = currClust;
    
end

%Remove all clusters that are formed from less than 5 variants
reducedClusterSet = {};
for i=1:numel(clusterSet)
   currClust = clusterSet{i};
   numvar = sum(currClust.existingVariants);
   
   if numvar>5
       reducedClusterSet = [reducedClusterSet {currClust}];
   end
   
   disp(i);
   
end
setHold = clusterSet;
clusterSet = reducedClusterSet;

disp('done');

%Sort clusters first by number of variants, then by number of members
numVars = cellfun(@(x) sum(x.existingVariants),clusterSet);
numMembers = cellfun(@(x) length(x.memberGrains),clusterSet);
mat = [numVars(:) numMembers(:)];
[B,I] = sortrows(mat,[-1 -2]);
clusterSet = clusterSet(I);


%%

%Cycle through each cluster, including in list only if there is no overlap
%with a previously included cluster
includedClusters = clusterSet(1);
clusterCombinedMembers = [clusterSet{1}.memberGrains.OIMgid];

for i=2:numel(clusterSet)
    
   currClust = clusterSet{i};
   currMemberIDs = [currClust.memberGrains.OIMgid];
   
   overlap = ismember(currMemberIDs,clusterCombinedMembers);
   if ~any(overlap)
       includedClusters = [includedClusters {currClust}];
       clusterCombinedMembers = [clusterCombinedMembers currMemberIDs];
   end
   
   disp(i);
    
end

%%

%Fill clusters and remove artifiacts
gIDmat = testgrainmap.gIDmat;
parfor i=1:numel(includedClusters)
    
    currClust = includedClusters{i};
    currClust.remove_cluster_artifacts(gIDmat);
    currClust.find_interior_grains(gIDmat);
   
    includedClusters{i} = currClust;
    
end


disp('done');

%Generate cluster ID matrix
[r,c] = size(gIDmat);
clusterIDmat = zeros(r,c);
for i=1:length(includedClusters)
    
    currClust = includedClusters{i};
    memberIDs = [currClust.memberGrains.OIMgid];
    interiorIDs = currClust.interiorNonMemberGrainIDs;
    includedIDs = [memberIDs interiorIDs];
    
    locs = ismember(gIDmat,includedIDs);
    clusterIDmat(locs) = i;
    
end


%%
%Find clusters that fit unallocated regions, with minimal overlap

allocatedRegions = logical(clusterIDmat);
unallocatedRegions = ~allocatedRegions;
[L,num] = bwlabel(unallocatedRegions,4);






%%
%Plot current IPF map

gIDmat = testgrainmap.gIDmat;
emptymap = containers.Map;
reconstructedIPFmap = IPFmap(gIDmat,emptymap);

for i=1:length(includedClusters)

    currCluster = includedClusters{i};


            IDs = [currCluster.memberGrains.OIMgid];

%             IDs = [[currCluster.memberGrains.OIMgid] currCluster.interiorNonMemberGrainIDs];


    Omap = containers.Map('KeyType','int32','ValueType','any');
    for j=1:length(IDs)
        Omap(IDs(j)) = currCluster.clusterOCenter;
    end

    reconstructedIPFmap.add_data(Omap);
    
    disp(i);

end

imshow(reconstructedIPFmap.IPFimage);