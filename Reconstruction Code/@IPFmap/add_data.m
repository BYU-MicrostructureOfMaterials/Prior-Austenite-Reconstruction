function add_data(obj,Omap)

    if ~isa(Omap,'containers.Map')     
        error('Input to IPFmap must be containers.Map object, where map keys correspond to ID matrix within IPFmap');
    end

    image = obj.IPFimage;
    Okeys = Omap.keys;
    Okeys = [Okeys{:}];
    orientations = Omap.values;
    notEmptyO = cellfun(@(x) ~isempty(x),orientations);
    rgb = zeros(length(orientations),3);
    
    orientations = [orientations{:}];
    if ~isempty(orientations)
        gmats = [orientations.g];
        gmats = reshape(gmats,3,3,[]);
        rgb(notEmptyO,:) = obj.IPF_rgbcalc(gmats);
        
        %temporary fix---------------
        [r,c] = find(isnan(rgb));
        rgb(r,c) = 1;
        %-----------------------------
    end

    for i=1:length(Okeys)

        currkey = Okeys(i);

        [rowinds,colinds] = find(obj.IDmat==currkey);

        if isempty(rowinds), error('Key not found in IDmat'); end

        for j=1:length(rowinds)

            row = rowinds(j);
            col = colinds(j);

            O = Omap(currkey);

            try
            image(row,col,1) = rgb(i,1);
            image(row,col,2) = rgb(i,2);
            image(row,col,3) = rgb(i,3);
            catch ME
                disp('here');
            end

        end
    end

    obj.IPFimage = image;

end