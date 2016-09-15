function genIPFmap(obj)

    gIDs = [obj.grains.OIMgid];
    map = containers.Map('KeyType','int32','ValueType','any');
    for i=1:length(gIDs)
        map(gIDs(i)) = obj.grains(gIDs==gIDs(i)).orientation;
    end

    obj.grainIPFmap = IPFmap(obj.gIDmat,map);

end