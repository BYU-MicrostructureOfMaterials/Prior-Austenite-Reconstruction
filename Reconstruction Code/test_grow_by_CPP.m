testreconstructor.gen_cluster_IDmat;

for i=testreconstructor.clusters
    
    i.grow_cluster_by_CPP(testreconstructor,10*pi/180);
    
end

%Sort clusters by increasing size and number of variants
for i=1:length(testreconstructor.clusters)
    numVars(i) = sum(testreconstructor.clusters(i).existingVariants);
    numMembers(i) = length(testreconstructor.clusters(i).memberGrains)+length(testreconstructor.clusters(i).includedNonMemberGrains);
%     testreconstructor.clusters(i).fill_cluster(testgrainmap);
end
mat = [numVars(:) numMembers(:)];
[B,I] = sortrows(mat,[1 2]);
testreconstructor.clusters = testreconstructor.clusters(I);

testreconstructor.genReconstructedIPFmap('filled');

%%

quats = q_NW_OR_gamma_to_alpha;

for i=1:length(quats(1,:))
    
    misos(:,i) = q_min_distfun(quats(:,i)',quats','cubic');
    
end
misos = misos*180/pi;
misos = round(misos,4);
misos = unique(misos);