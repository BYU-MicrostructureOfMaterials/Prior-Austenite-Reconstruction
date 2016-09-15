function grow_cluster(obj,reconstructor)

    load quat_cubic_symops;

    %Initialize cluster member data
    grainPool = reconstructor.daughterGrains;
    obj.memberGrains = [obj.memberGrains  grainPool(obj.startTrio.parentTripletIDs)];
    clustPAquats = [obj.startTrio.orientations.quat];
    clusterOCenter_q = obj.clusterOCenter.quat;

    %Grow cluster
    clustChanged = true;
    while clustChanged

        clustChanged = false;

        %Get neighbor grains to current set of cluster members
        neighborIDs = intersect(setdiff(unique([obj.memberGrains.neighborIDs]),[obj.memberGrains.OIMgid]),[grainPool.OIMgid]);
        neighborGrains = grainPool(neighborIDs);

        for i=1:length(neighborGrains) %for each neighbor check if it has a PA within tol of cluster center

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

        %If any current member grains have selected PA outside of new window, remove
        outsideWindow = q_min_distfun(clusterOCenter_q',clustPAquats','cubic')>obj.misoTolerance;
        if any(outsideWindow)
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