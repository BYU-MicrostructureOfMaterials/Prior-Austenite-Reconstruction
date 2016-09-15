function find_trios(obj)

    disp('Finding trios');

    tripletArray = obj.triplets;
    cutoff = obj.trioCutoffMiso;
    parfor i=1:length(obj.triplets)
        currTriplet = tripletArray(i);
        currTriplet.calc_trios(cutoff);
        tripletArray(i) = currTriplet;
    end
    
    %Filter out all triplets that have all possible parents as trios
    if strcmp(obj.OR,'KS')
        nVariants = 24;
    elseif strcmp(obj.OR,'NW')
        nVariants = 12;
    end
    
    toRemove = false(1,length(tripletArray));
    for i=1:length(tripletArray)
        numTrios = length(tripletArray(i).parentPhaseTrios);
        if numTrios==nVariants
            toRemove(i) = true;
        end
    end
    tripletArray = tripletArray(~toRemove);

    obj.triplets = tripletArray;
    
    disp('Sorting trios');
    
    %Sort trios
    trioArray = [tripletArray.parentPhaseTrios];
    misos = [trioArray.misoSum];
    [B,I] = sort(misos);
    trioArray = trioArray(I);
    
    %Filter trios
    currTrioInd = 1;
    numTrios = length(trioArray);
    while currTrioInd<numTrios
        
        trioMemberIDs = [trioArray.tripletGrainIDs]';
        trioAvgOrientations = [trioArray.avgOrientation];
        trioAvgOrientationsQ = [trioAvgOrientations.quat];
        
        currTrio = trioArray(currTrioInd);
        currTrioMemberIDs = currTrio.tripletGrainIDs';
        
        %Mark trios that have overlapping members
        overlapping = any(ismember(trioMemberIDs,currTrioMemberIDs),2);
        
        %Mark trios that have averaged PA orientations within tolerance
        closePA = q_min_distfun(currTrio.avgOrientation.quat',trioAvgOrientationsQ','cubic')<obj.trioCutoffMiso;
        
        toremove = and(overlapping,closePA);
        toremove(currTrioInd) = false;
        
        trioArray = trioArray(~toremove);
        
        currTrioInd = currTrioInd + 1;
        numTrios = length(trioArray);
    end
    
    obj.trios = trioArray;
    
    disp(['Done calculating trios: ', num2str(length(trioArray)), ' trios found']);

end