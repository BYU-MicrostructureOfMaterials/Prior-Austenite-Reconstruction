
testreconstructor.genReconstructedFilteredIPFmap('membersOnly');
testreconstructor.gen_filtered_cluster_IDmat;
clusterIDmat = testreconstructor.filteredClusterIDmat;
IPFmap = testreconstructor.reconstructedFilteredIPFmap;

%For each excluded cluster, check if would make a good fit after handling
%all overlap.
for i=1:numel(testreconstructor.temp)

    currClust = testreconstructor.temp(i);    
    
    %Place in IPF map to visualize overlap
    currMemberIDs = [currClust.memberGrains.OIMgid];
    Omap = containers.Map('KeyType','int32','ValueType','any');
    for j=1:length(currMemberIDs)
        Omap(currMemberIDs(j)) = currClust.clusterOCenter;
    end
    
    IPFmap.add_data(Omap);
    imshow(IPFmap.IPFimage);

    %Get find all included clusters that this cluster overlaps with
    currLocs = currClust.scanLocations;
    overlapClusterIDs = clusterIDmat(currLocs);
    overlapClusterIDs = unique([overlapClusterIDs{:}]);
    
    disp('here');
end

%%

gIDmat = testreconstructor.grainmap.gIDmat;    
compClust = testreconstructor.filteredClusters([testreconstructor.filteredClusters.ID]==overlapClusterIDs(2));
compare_two_clusters(compClust,currClust,gIDmat);

currTheoVars = currClust.theoreticalVariants;
compTheoVars = compClust.theoreticalVariants(compClust.existingVariants);

overlappingVar = false(1,length(compTheoVars));
for k=1:numel(compTheoVars)
    overlappingVar(k) = any(q_min_distfun(compTheoVars(k).quat',[currTheoVars.quat]','cubic')<(5.2*pi/180)); 
end