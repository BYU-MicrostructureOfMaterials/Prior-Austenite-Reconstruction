function find_triplets(obj,selectedSet)
    
    %Define set of grain IDs that can be part of a triplet
    grainPool = obj.daughterGrains;
    poolIDs = [grainPool.OIMgid];

    if nargin==1
        includedGIDs = poolIDs;
    elseif nargin==2
        includedGIDs = intersect(selectedSet,poolIDs);
    end
    
    %Initialize empty list of triplets. For each included grain, search for
    %all triplets that it is a part of
    tripletContainer = {};
    
    minNeighborMiso = obj.tripletMinNeighborMiso;
    while ~isempty(includedGIDs)

        %Pull current grain and its ID from pool
        currGrainGID = includedGIDs(1);
        currGrain = grainPool(poolIDs==currGrainGID); %Grain A of possible triplet

        %Extract neighbor list for current grain
        neighborGIDs = intersect(currGrain.neighborIDs,includedGIDs); %currGrain.neighborIDs may contain IDs of grains of different phases

        while ~isempty(neighborGIDs)

            %Pull current neighbor to current grain A
            currNeighborGID = neighborGIDs(1);
            currNeighbor = grainPool(poolIDs==currNeighborGID); %Grain B of possible triplet

            %Calculate current neighbor's misorientation with current grain (grain A)
            AtoBmiso = q_min_distfun(currGrain.orientation.quat',currNeighbor.orientation.quat','cubic');

            if (AtoBmiso>minNeighborMiso)

                %Pull list of grains that are common neighbors of current grains A and B
                commonNeighborGIDs = intersect(neighborGIDs,currNeighbor.neighborIDs);
                commonNeighbors = grainPool(ismember(poolIDs,commonNeighborGIDs));

                for k = 1:length(commonNeighbors)

                    %Pull current common neighbor and find its misorientation with grains A and B
                    currCommonNeighbor = commonNeighbors(k); %Grain C of possible triplet
                    CtoAmiso = q_min_distfun(currGrain.orientation.quat',currCommonNeighbor.orientation.quat','cubic');
                    CtoBmiso = q_min_distfun(currNeighbor.orientation.quat',currCommonNeighbor.orientation.quat','cubic');

                    if (CtoBmiso>minNeighborMiso && CtoAmiso>minNeighborMiso)

                        triplet = Triplet([currGrain currNeighbor currCommonNeighbor]);
                        tripletContainer = [tripletContainer {triplet}];

                    end

                end  

            end

            %Update list of neighbor IDs, removing current neighbor from list
            neighborGIDs = setdiff(neighborGIDs,currNeighborGID);

        end

        %Update included IDs, removing current grain from the list
        includedGIDs = setdiff(includedGIDs,currGrainGID);

    end

    obj.triplets = [tripletContainer{:}];
    disp('Done finding triplets');

end