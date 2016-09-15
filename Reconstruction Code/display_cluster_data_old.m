IDs = [testreconstructor.clusters.ID];%clusterIDs;


for i=1:length(IDs)%length(combinedreconstructor.clusters)
   
   currClust = testreconstructor.clusters(ismember([testreconstructor.clusters.ID],IDs(i)));
%    currClust = testreconstructor.filteredClusters([testreconstructor.filteredClusters.ID]==i);
%     currClust = testreconstructor.clusters(ismember([testreconstructor.specialClusters.ID],IDs(i)));
   
   Omap = containers.Map('KeyType','int32','ValueType','any');
   
%    clustMembers = [currClust.memberGrains.OIMgid];
   clustMembers = [[currClust.memberGrains.OIMgid] [currClust.includedNonMemberGrains.OIMgid]];

   for j=1:length(clustMembers)
       Omap(clustMembers(j)) = currClust.clusterOCenter; 
   end
   
   IPF = IPFmap(testreconstructor.grainmap.gIDmat,Omap);
   figure(1);
   pos = get(gcf,'Position');
   imshow(IPF.IPFimage);
   set(gcf,'Position',pos);
   
   clustCenterQ = currClust.clusterOCenter.quat;
%    clustMemberO = [currClust.memberGrains.orientation];
   clustMemberO = [[currClust.memberGrains.orientation] [currClust.includedNonMemberGrains.orientation]];
   clustMemberQ = [clustMemberO.quat];
   
   clustTheoreticalVarsQ = [currClust.theoreticalVariants.quat];
   
   figure(2);
   clf;
   
   pole_figure_by_quat(clustMemberQ',[],[],'k.',1,2);
   pole_figure_by_quat(clustCenterQ',[],[],'rd',3,2);
   pole_figure_by_quat(clustTheoreticalVarsQ',[],[],'bd',3,2);
   numVar = sum(currClust.existingVariants);
   title(['cluster ',num2str(IDs(i)),': ',num2str(numVar)]);
   
   disp('here');
   
    
end