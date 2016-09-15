function individual_grain_IPFmap(obj, gIDmat)

    Omap = containers.Map('KeyType','int32','ValueType','any');

    Omap(obj.OIMgid) = obj.orientation;

    individualGrainIPFmap = IPFmap(gIDmat,Omap);
    imshow(individualGrainIPFmap.IPFimage);


end