function find_trios(obj)
            
    tripletArray = obj.triplets;
    cutoff = obj.trioCutoffMiso;
    parfor i=1:length(obj.triplets)
        currTriplet = tripletArray(i);
        currTriplet.calc_trios(cutoff);
        tripletArray(i) = currTriplet;
    end

    obj.triplets = tripletArray;
    
    %Sort trios
    trioArray = [tripletArray.parentPhaseTrios];
    misos = [trioArray.misoSum];
    [B,I] = sort(misos);
    trioArray = trioArray(I);
    
    %Filter trios
    currTrioInd = 1;
    numTrios = length(trioArray);
    while currTrioInd<numTrios
        
        trioMemberIDs = [trioArray.parentTripletIDs]';
        trioAvgOrientations = [trioArray.avgOrientation];
        trioAvgOrientationsQ = [trioAvgOrientations.quat];
        
        currTrio = trioArray(currTrioInd);
        currTrioMemberIDs = currTrio.parentTripletIDs';
        
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
    
    disp('Done calculating trios');

end