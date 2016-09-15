function divide_AR_by_exhaustive_search(obj,clusterA,clusterB)
    
global numRuns
numRuns = 0;


    %Extract region of scan
    if any(~(size(clusterA.scanLocations)==size(clusterB.scanLocations)))
        error('Input clusters not from same scan (location matrices for both clusters do not match in size)');
    end
    
    [nrows,ncols] = size(clusterA.scanLocations);
    [Arows,Acols] = find(clusterA.scanLocations);
    [Brows,Bcols] = find(clusterB.scanLocations);
    
    minrow = min([Arows; Brows]);
    mincol = min([Acols; Bcols]);
    maxrow = max([Arows; Brows]);
    maxcol = max([Acols; Bcols]);
    
    if minrow>1, minrow = minrow - 1; end
    if maxrow<nrows, maxrow = maxrow + 1; end
    if mincol>1, mincol = mincol - 1; end
    if maxcol<ncols, maxcol = maxcol + 1; end
    
    %Extract local area of grainID matrix
    gIDmat = obj.grainmap.gIDmat(minrow:maxrow,mincol:maxcol);
    
    %Extract regions of scan that exclusively belong to clusters A or B
    overlapGrains = intersect([[clusterA.memberGrains] [clusterA.includedNonMemberGrains]],[[clusterB.memberGrains] [clusterB.includedNonMemberGrains]]);
    exclusiveAGrains = setdiff([[clusterA.memberGrains] [clusterA.includedNonMemberGrains]],overlapGrains);
    exclusiveBGrains = setdiff([[clusterB.memberGrains] [clusterB.includedNonMemberGrains]],overlapGrains);
    
    exclusiveARegion = ismember(gIDmat,[exclusiveAGrains.OIMgid]);
    exclusiveBRegion = ismember(gIDmat,[exclusiveBGrains.OIMgid]);
    
    [numRegions, grainRegions] = num_regions(overlapGrains);
    
    tree = erosionTree(gIDmat,[grainRegions{2}.OIMgid],exclusiveBRegion);
    
    
%     for i=1:numRegions
%         
%         grainSet = grainRegions(i);
%         
%         
%         
%     end
    
    

end

function tree = erosionTree(gIDmat,grainIDs,region)

    global numRuns
    numRuns = numRuns + 1;

    %Find all grains having only one boundary with region
    numSegments = zeros(1,length(grainIDs));
    for i=1:length(grainIDs)
        currGrainRegion = gIDmat==grainIDs(i);
        numSegments(i) = num_segments(currGrainRegion,region);
    end
    feasibleGrainIDs = grainIDs(numSegments==1);
    
    %For each feasible grain, flip and consider subsequent erosion paths
    for i=1:length(feasibleGrainIDs)

        %Flip slected grain to the boundary region (remove from grain
        %region and add to bounding region)
        selectedGrainID = feasibleGrainIDs(i);
        remainingGrainIDs = grainIDs(~ismember(grainIDs,selectedGrainID));
        updatedRegion = or(region,gIDmat==selectedGrainID);

%         %------------------------------------------------------------------
%         
%         %IF DETECTING BOUNDARIES USING 4-CONNECTED PIXELS (in num_segments)           
%
%         %NOTE: Some grains include corner-pixels. If such a grain is
%         %flipped to the bounding region, this leaves corner-connected holes
%         %along the boundary of the remaining grain region. In subsequent steps
%         %determining the number of boundary segments a grain has with the
%         %boundary region, these corner holes will count as extra boundary
%         %segments, since boundary segments are defined using 4-connected
%         %groups of pixels (8-connected groups cannot be used to count
%         %boundary segments, as this will cause some grains to form a
%         %boundary segment that ignores smaller grains on its surface). In
%         %order to avoid this, corner connected holes within the remaining grain
%         %region are removed from the bounding region and left belonging to
%         %neither the remaining grain region, nor the bounding region. This
%         %opens up another problem, being orphaned pixels along the new
%         %4-connected boundary that again cause unintentional breaks in the
%         %boundary segments of larger grains. These problems are solved by
%         %performing the following sequence:
%         % - Flip the selected grain over to the bounding region
%         % - Fill any 8-connected holes in the remaining grain region, and
%         %   remove those pixels from the bounding region
%         % - Find all orphaned pixels that are 4-connected to the bounding
%         %   region, and add to the bounding region
%         
%         %Flip slected grain to the boundary region (remove from grain
%         %region and add to bounding region)
%         selectedGrainID = feasibleGrainIDs(i);
%         remainingGrainIDs = grainIDs(~ismember(grainIDs,selectedGrainID));
%         remainingGrainRegion = ismember(gIDmat,remainingGrainIDs);
%         
%         %Fill in the remaining grain region using 4 connectivity
%         filledGrainRegion = region_fill_holes(remainingGrainRegion,4);
%         updatedRegion = or(region,gIDmat==selectedGrainID);
%         updatedRegion = and(updatedRegion,~filledGrainRegion);
%         
%         %Fill in any orphaned pixels left behind by previous fill-ins of
%         %filledGrainRegion by adding 4-connected orphaned pixels to
%         %bounding region
%         
%         %code here
%         
%         %------------------------------------------------------------------

        if length(remainingGrainIDs)>0 %there is more than one grain remaining
            
            treeHold = erosionTree(gIDmat,remainingGrainIDs,updatedRegion);

            for j=1:length(treeHold(:,1))
                expandedHold(j,:) = [selectedGrainID treeHold(j,:)];
            end
            
            if i==1
                tree = expandedHold;
            else
                tree = [tree; expandedHold];
            end
            
        else

            tree = selectedGrainID;

        end

    end

end

function [numRegions, regions] = num_regions(grains)

    unAssigned = grains;
    assigned = Grain.empty;
    
    numRegions = 0;
    while ~isempty(unAssigned)
        
        currRegion = unAssigned(1);
        unAssigned = setdiff(unAssigned,currRegion);
        assigned = union(assigned,currRegion);
        
        regionFull = false;
        while ~regionFull
            
            regionNeighborIDs = [currRegion.neighborIDs];
            neighborIDsToAdd = regionNeighborIDs(ismember(regionNeighborIDs,[unAssigned.OIMgid]));
            grainsToAdd = unAssigned(ismember([unAssigned.OIMgid],neighborIDsToAdd));
            
            if isempty(grainsToAdd)
                regionFull = true;
                numRegions = numRegions + 1;
                regions{numRegions} = currRegion;
            else
                currRegion = union(currRegion,grainsToAdd);
                unAssigned = setdiff(unAssigned,currRegion);
                assigned = union(assigned,currRegion);
            end
            
        end
        
    end

end

function numSegments = num_segments(grainMask,regionMask)

    shell = extract_boundary(grainMask);
    segments = and(shell,regionMask);
    
    IDs = region_label(segments,8);
    numSegments = length(setdiff(unique(IDs),0));
    
end

