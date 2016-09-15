function remove_cluster_artifacts(obj,gIDmat)

    memberGrainIDs = [obj.memberGrains.OIMgid];

    %Check that none of the grains in "memberGrains" are empty
    %grain objects
    if numel(memberGrainIDs)~=numel(obj.memberGrains)
        error('Cluster contains empty grain object, cannot remove artifacts');
    end

    interiorGrainIDs = obj.interiorNonMemberGrainIDs;
    includedIDs = [memberGrainIDs interiorGrainIDs];
    clusterLocs = ismember(gIDmat,includedIDs);

    [L,num] = bwlabel(clusterLocs,4);

    sizes = zeros(1,num);
    for i=1:num
        sizes(i) = sum(sum(L==i));
    end

    [maxSize,largestGroup] = max(sizes);

    largestRegion = (L==largestGroup);
    newIncludedIDs = gIDmat(largestRegion);

    includedMemberGrainInds = ismember(memberGrainIDs,newIncludedIDs);
    obj.memberGrains = obj.memberGrains(includedMemberGrainInds);
    obj.parentPhaseOrientations = obj.parentPhaseOrientations(includedMemberGrainInds);

    %Recalculate ClusterOcenter to account for removed cluster
    %members.
    load quat_cubic_symops;
    clusterOCenter_q = obj.clusterOCenter.quat;
    clustPAquats = [obj.parentPhaseOrientations.quat];
    [rotated_quats,clusterOCenter_q] = q_average_orientations_in_window(clustPAquats,clusterOCenter_q,obj.misoTolerance,quat_cubic_symops);
    obj.clusterOCenter = Orientation(clusterOCenter_q,'quat');

    %Again, remove any grains that now lie out of window
    outsideWindow = q_min_distfun(clusterOCenter_q',clustPAquats','cubic')>obj.misoTolerance;
    if any(outsideWindow)
        obj.memberGrains = obj.memberGrains(~outsideWindow);
        obj.parentPhaseOrientations = obj.parentPhaseOrientations(~outsideWindow);
    end 

    %Update list of interior filled grains to reflect artifact
    %removal
    obj.interiorNonMemberGrainIDs = intersect(newIncludedIDs,obj.interiorNonMemberGrainIDs)';

end