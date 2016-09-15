function grow_cluster(obj,reconstructor)

    load quat_cubic_symops;

    %Initialize cluster member data
    grainPool = reconstructor.daughterGrains;
    poolIDs = [grainPool.OIMgid];
    
    startGrainA = grainPool(poolIDs==obj.startTrio.parentTripletIDs(1)); %This is necessary to enforce order of grains in list
    startGrainB = grainPool(poolIDs==obj.startTrio.parentTripletIDs(2));
    startGrainC = grainPool(poolIDs==obj.startTrio.parentTripletIDs(3));
    
    obj.memberGrains = [startGrainA startGrainB startGrainC];
    clustPAquats = [obj.startTrio.PAorientations.quat]; %Order of quaternions must match order of member grains
    
    clusterOCenter_q = obj.clusterOCenter.quat;

    %Grow cluster
    
    grainFrames = [];
    poleFrames = [];
    
    clustChanged = true;
    while clustChanged
        
 %%%%%%%%%%%%%%%%%%%%%%FOR DEMONSTRATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
%         obj.genClusterIPFmap(reconstructor.grainmap.gIDmat,'daughterGrains','filled',1);
%         axis tight;
%         grainFrames = [grainFrames getframe];
% %         obj.genClusterIPFmap(reconstructor.grainmap.gIDmat,'parentAverage','filled',1);
% 
%         memberOs = [obj.memberGrains.orientation];
%         memberQs = [memberOs.quat];
%         pole_figure_by_quat(memberQs',[],[],'k.',1,2);
%         pole_figure_by_quat(clustPAquats',[],[],'bd',2,2);
%         title('[0 0 1]');
%      
%         poleFrames = [poleFrames getframe];
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        clustChanged = false;

        %Get neighbor grains to current set of cluster members
        clustNeighbors = unique([[obj.memberGrains.neighborIDs] [obj.includedNonMemberGrains.neighborIDs]]);
        clustMembers = [[obj.memberGrains.OIMgid] [obj.includedNonMemberGrains.OIMgid]];
        neighborIDs = intersect(setdiff(clustNeighbors,clustMembers),poolIDs);
        neighborGrains = grainPool(ismember(poolIDs,neighborIDs));
        
        %For each neighbor check if it has a PA within tolerance of averaged PA cluster center
        for i=1:length(neighborGrains)

            currNeighbor = neighborGrains(i);
            currNeighPAquats = [currNeighbor.newPhaseOrientations.quat];
            inWindow = q_min_distfun(clusterOCenter_q',currNeighPAquats','cubic')<obj.misoTolerance;

            if any(inWindow) %if current neighbor has PA in window, add to group
                if sum(inWindow)>1 
                    error('Neighbor grain contains multiple possible parents within window'); 
                end

                obj.memberGrains = [obj.memberGrains currNeighbor];
                clustPAquats = [clustPAquats currNeighPAquats(:,inWindow)];
                clustChanged = true;

            end

        end

        %Calculate new average cluster center
        [rotated_quats,clusterOCenter_q] = q_average_orientations_in_window(clustPAquats,clusterOCenter_q,obj.misoTolerance,quat_cubic_symops);   

        %If any included non-member grains have PA within the new window, move into member list
        nonMemberHold = obj.includedNonMemberGrains;
        for i=1:length(nonMemberHold)
            
            currNonMember = nonMemberHold(i);
            currNonMemberPAquats = [currNonMember.newPhaseOrientations.quat];
            inWindow = q_min_distfun(clusterOCenter_q',currNonMemberPAquats','cubic')<obj.misoTolerance;
            
            if any(inWindow) %if current non-member has PA in window, add to group
                if sum(inWindow)>1 
                    error('Non-member grain contains multiple possible parents within window'); 
                end

                obj.memberGrains = [obj.memberGrains currNonMember];
                clustPAquats = [clustPAquats currNonMemberPAquats(:,inWindow)];
                obj.includedNonMemberGrains = setdiff(obj.includedNonMemberGrains,currNonMember);

            end
              
        end
        
        %If any current member grains have selected PA outside of new window, move to included non-member list
        outsideWindow = q_min_distfun(clusterOCenter_q',clustPAquats','cubic')>obj.misoTolerance;
        if any(outsideWindow)
            obj.includedNonMemberGrains = [obj.includedNonMemberGrains obj.memberGrains(outsideWindow)];
            obj.memberGrains = obj.memberGrains(~outsideWindow);
            clustPAquats = clustPAquats(:,~outsideWindow);
        end 
    
    end

    %Update obj.clusterOCenter and obj.parentPhaseOrientations
    obj.clusterOCenter = Orientation(clusterOCenter_q,'quat');
    for i=1:length(clustPAquats(1,:))
        obj.parentPhaseOrientations = [obj.parentPhaseOrientations Orientation(clustPAquats(:,i),'quat')];
    end

end