
function compare_two_clusters(clusterA,clusterB,gIDmat,filledtype)

IPF = IPFmap(gIDmat,containers.Map);
Omap = containers.Map('KeyType','int32','ValueType','any');

switch filledtype
    case 'membersOnly'
        clustAmemberIDs = [clusterA.memberGrains.OIMgid];
        clustBmemberIDs = [clusterB.memberGrains.OIMgid];
        
        clusterAmemberO = [clusterA.memberGrains.orientation];
        clusterBmemberO = [clusterB.memberGrains.orientation];
        
    case 'filled'
        clustAmemberIDs = [[clusterA.memberGrains.OIMgid] [clusterA.includedNonMemberGrains.OIMgid]];
        clustBmemberIDs = [[clusterB.memberGrains.OIMgid] [clusterB.includedNonMemberGrains.OIMgid]];
        
        clusterAmemberO = [[clusterA.memberGrains.orientation] [clusterA.includedNonMemberGrains.orientation]];
        clusterBmemberO = [[clusterB.memberGrains.orientation] [clusterB.includedNonMemberGrains.orientation]];
end

for i=1:length(clustAmemberIDs)
    Omap(clustAmemberIDs(i)) = clusterA.clusterOCenter;
end

for i=1:length(clustBmemberIDs)
    Omap(clustBmemberIDs(i)) = clusterB.clusterOCenter;
end

IPF.add_data(Omap);
figure;
imshow(IPF.IPFimage);


clusterAcenterQ = clusterA.clusterOCenter.quat;
clusterAmemberQ = [clusterAmemberO.quat];
clusterAtheoreticalVars = [clusterA.theoreticalVariants.quat];

clusterBcenterQ = clusterB.clusterOCenter.quat;
clusterBmemberQ = [clusterBmemberO.quat];
clusterBtheoreticalVars = [clusterB.theoreticalVariants.quat];

miso = q_min_distfun(clusterAcenterQ',clusterBcenterQ','cubic');

fig = figure;

pole_figure_by_quat(clusterAcenterQ',[],[],'rd',3,fig.Number);
pole_figure_by_quat(clusterAtheoreticalVars',[],[],'rd',3,fig.Number);
pole_figure_by_quat(clusterAmemberQ',[],[],'r.',1,fig.Number);

pole_figure_by_quat(clusterBcenterQ',[],[],'bd',3,fig.Number);
pole_figure_by_quat(clusterBtheoreticalVars',[],[],'bd',3,fig.Number);
pole_figure_by_quat(clusterBmemberQ',[],[],'b.',1,fig.Number);
title(['Miso: ',num2str(miso*180/pi)]);

end
