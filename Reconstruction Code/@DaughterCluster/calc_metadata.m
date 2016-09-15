
%This function should be (able to be) called after any change to the
%cluster: members of the cluster, PA orientation, if the cluster has been
%filled, etc.

function calc_metadata(obj,gIDmat,filledtype)

    %Detect what child variants make up cluster
    switch obj.OR
        case 'KS'
            load q_KS_OR_gamma_to_alpha;
            q_trans = q_KS_OR_gamma_to_alpha;
        case 'NW'
            load q_NW_OR_gamma_to_alpha;
            q_trans = q_NW_OR_gamma_to_alpha;
    end
    Nvar = length(q_trans(1,:));

    %Generate theoretical daughter variants for PA cluster
    variants_q = zeros(4,Nvar);
    for i=1:Nvar
        variants_q(:,i) = quatLmult(q_trans(:,i),obj.clusterOCenter.quat);
        O(i) = Orientation(variants_q(:,i),'quat');
    end
    obj.theoreticalVariants = O;

    %Cycle through each member grain and count which variant group
    %it belongs to
    obj.variantGIDs = cell(1,Nvar);
    for i=1:length(obj.memberGrains)

        q_currDaughterO = obj.memberGrains(i).orientation.quat;
        varMisos = q_min_distfun(q_currDaughterO',variants_q','cubic');

        inWindow = varMisos<obj.misoTolerance;

        if sum(inWindow)~= 1, 
            error('Cluster member fails comparison to theoretical variants'); 
        end

        obj.variantGIDs{inWindow} = [obj.variantGIDs{inWindow} obj.memberGrains(i).OIMgid];

    end

    obj.existingVariants = cellfun(@(x) any(x),obj.variantGIDs);

    %Calc the number of scanpoints that are in cluster
    switch filledtype
        case 'filled'
            memberGIDs = [[obj.memberGrains.OIMgid] [obj.includedNonMemberGrains.OIMgid]];
        case 'membersOnly'
            memberGIDs = [obj.memberGrains.OIMgid];
    end
    obj.scanLocations = ismember(gIDmat,memberGIDs);

end