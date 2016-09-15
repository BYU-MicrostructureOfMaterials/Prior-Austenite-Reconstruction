function find_confirmed_boundaries(obj)

   %--------------------------------------------------------------- 
   %Generate known PA boundaries by finding all pixels over which
   %no cluster crosses
   %---------------------------------------------------------------
    gIDmat = obj.grainmap.gIDmat;
    [r,c] = size(gIDmat);
    clustermap = obj.clusterMap;

    %Cycle through each pixel of the scan, making each pair of pixels that
    %represents a boundary between exclusive sets of clusters claiming those
    %pixels
    boundaries = ones(r,c);

    %first cycle through rows
    for i=1:r
        for j=1:c-1
            %compare current pixel with pixel to the right. If the sets of
            %cluster IDs for both pixels are mutually exclusive, then mark both 
            %as a boundary
            pixel1clusters = clustermap{i,j};
            pixel2clusters = clustermap{i,j+1};

            if ~any(intersect(pixel1clusters,pixel2clusters))
                boundaries(i,j) = 0;
                boundaries(i,j+1) = 0;
            end

        end
    end

    %cycle through columns
    for j=1:c
        for i=1:r-1
            %compare current pixel with pixel to the right. If the sets of
            %cluster IDs for both pixels are mutually exclusive, then mark both 
            %as a boundary
            pixel1clusters = clustermap{i,j};
            pixel2clusters = clustermap{i+1,j};

            if ~any(intersect(pixel1clusters,pixel2clusters))
                boundaries(i,j) = 0;
                boundaries(i+1,j) = 0;
            end

        end
    end

    obj.confirmedBoundaryMap = boundaries;

    %--------------------------------------------------------------
    %For each cluster, extract its boundary and calculate how much
    %of that boundary lies on a confirmed PA boundary
    %--------------------------------------------------------------

    %Include some sense of convex/concave regions? 



end