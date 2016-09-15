function display_cluster_data(gIDmat,clusters,IPFfilledtype,polefigFilledtype,IPFfignum,polefigFignum)

for i=clusters
    
    figure(IPFfignum);
    pos = get(gcf,'Position');
    clf;
    
    switch IPFfilledtype
        case 'filled'
            i.genClusterIPFmap(gIDmat, 'parentAverage', 'filled', IPFfignum);
        case 'membersOnly'
            i.genClusterIPFmap(gIDmat, 'parentAverage', 'membersOnly', IPFfignum);
    end
    
    set(gcf,'Position',pos);
    
    switch polefigFilledtype
        case 'filled'
            clustMemberO = [[i.memberGrains.orientation] [i.includedNonMemberGrains.orientation]];
        case 'membersOnly'
            clustMemberO = [i.memberGrains.orientation];
    end
    
    clustCenterQ = i.clusterOCenter.quat;
    clustTheoreticalVarsQ = [i.theoreticalVariants.quat];
    clustMemberQ = [clustMemberO.quat];
    
    figure(polefigFignum);
    clf;
    
    pole_figure_by_quat(clustMemberQ',[],[],'k.',1,2);
    pole_figure_by_quat(clustCenterQ',[],[],'rd',3,2);
    pole_figure_by_quat(clustTheoreticalVarsQ',[],[],'bd',3,2);
    numVar = sum(i.existingVariants);
    title(['cluster ',num2str(i.ID),': ',num2str(numVar)]);
    
    pause;

end

end