function genClusterIPFmap(obj, IDmat, type, filledtype,fignum)

    grains = obj.memberGrains;

    switch filledtype
        case 'membersOnly'
            grains = obj.memberGrains;
        case 'filled'
            grains = [obj.memberGrains obj.includedNonMemberGrains(:)'];
    end

    Omap = containers.Map('KeyType','int32','ValueType','any');
    for i=1:length(grains)

        switch type
            case 'parentAverage'
                O = obj.clusterOCenter;
            case 'daughterGrains'
                O = grains(i).orientation;
        end

        Omap(grains(i).OIMgid) = O;

    end

    obj.clusterIPFmap = IPFmap(IDmat,Omap);
    figure(fignum);
    imshow(obj.clusterIPFmap.IPFimage);

end