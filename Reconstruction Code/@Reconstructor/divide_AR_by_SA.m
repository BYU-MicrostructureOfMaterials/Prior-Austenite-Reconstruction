function divide_AR_by_SA(obj,clusterA,clusterB)

global reconstructor
reconstructor = obj;

%Extract region of scan
if any(~(size(clusterA.scanLocations)==size(clusterB.scanLocations))) || any(~(size(clusterA.scanLocations)==size(obj.grainmap.gIDmat)))
    error('Input clusters not from same scan (location matrices for both clusters do not match with each other or grainmap in size)');
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

gIDmat = obj.grainmap.gIDmat(minrow:maxrow,mincol:maxcol);

%Determine best starting point for SA algorithm (all assigned to A or B)
exclusiveA = and(clusterA.scanLocations,~clusterB.scanLocations);
exclusiveB = and(clusterB.scanLocations,~clusterA.scanLocations);
[Ashell,Bshell,boundary,BL_allocA] = extract_boundary(exclusiveB,clusterA.scanLocations);
[Ashell,Bshell,boundary,BL_allocB] = extract_boundary(exclusiveA,clusterB.scanLocations);

if BL_allocA<=BL_allocB %Then keep grains in cluster B, remove from A
    regionA = clusterA.scanLocations(minrow:maxrow,mincol:maxcol);
    regionB = and(clusterB.scanLocations(minrow:maxrow,mincol:maxcol),~regionA);
else %Then keep grains in cluster A, remove from B
    regionB = clusterB.scanLocations(minrow:maxrow,mincol:maxcol);
    regionA = and(clusterA.scanLocations(minrow:maxrow,mincol:maxcol),~regionB);
end

%With starting two region defined, extract grain IDs
commonRegion = and(clusterA.scanLocations(minrow:maxrow,mincol:maxcol),clusterB.scanLocations(minrow:maxrow,mincol:maxcol));
if ~any(any(commonRegion))
    warning('Clusters do not overlap');
    return
end

commonRegion_IDs = unique(gIDmat(commonRegion));
regionA_IDs = unique(gIDmat(regionA));
regionB_IDs = unique(gIDmat(regionB));

%Detect which grains in the common region lay on boundary
[Ashell,Bshell,boundary, BL] = extract_boundary(regionA,regionB);
boundaryA_IDs = regionA_IDs(ismember(regionA_IDs,gIDmat(boundary)));
boundaryA_IDs = boundaryA_IDs(ismember(boundaryA_IDs,commonRegion_IDs));
boundaryB_IDs = regionB_IDs(ismember(regionB_IDs,gIDmat(boundary)));
boundaryB_IDs = boundaryB_IDs(ismember(boundaryB_IDs,commonRegion_IDs));

%Run simulated annealing
startTemp = -1/log(obj.startAcceptP);
endTemp = -1/log(obj.endAcceptP);
frac = (endTemp/startTemp)^(1/(obj.numTemps-1)); %Fraction of reduction for each new temperature

avg_BL_change = 0;
bestResultA = regionA;
bestResultB = regionB;
bestResultBL = BL;

T = startTemp;
numAccepted = 0;
for i=1:obj.numTemps
    for j=1:obj.numTrials
        
        %Test current state to determine if one cluster has been completely
        %consumed (interior cluster that was not filtered out) or if the
        %Two clusters do not intersect (One cluster was split into two
        %parts by a previous case of overlap). If so,return
        regionASize = sum(sum(regionA));
        regionBSize = sum(sum(regionB));
        if regionASize<10 || (regionASize/sum(sum(clusterA.scanLocations)))<.1 
            %ClusterA has been consumed. Move to filtered clusters
            obj.filteredClusters = [obj.filteredClusters clusterA];
            obj.clusters = obj.clusters([obj.clusters.ID]~=clusterA.ID);
            return
        elseif regionBSize<10 || (regionBSize/sum(sum(clusterB.scanLocations)))<.1
            %ClusterB has been consumed. Move to filtered clusters
            obj.filteredClusters = [obj.filteredClusters clusterB];
            obj.clusters = obj.clusters([obj.clusters.ID]~=clusterB.ID);
            return
        elseif isempty(boundaryA_IDs) && isempty(boundaryB_IDs)
            %Clusters no longer share boundary with each other
            update_clusters(gIDmat,clusterA,clusterB,regionA,regionB);
            return
        end
         
        %Get next trial
        flipGrainID = next_trial(boundaryA_IDs,boundaryB_IDs);
        flipRegion = gIDmat==flipGrainID;
        
        if any(ismember(boundaryA_IDs,flipGrainID)) %Is member of region A, flip to B
            newRegionA = and(regionA,~flipRegion);
            newRegionB = or(regionB,flipRegion);
        elseif any(ismember(boundaryB_IDs,flipGrainID)) %Is member of region B, flip to A
            newRegionB = and(regionB,~flipRegion);
            newRegionA = or(regionA,flipRegion);
        end
        
        %Calculate change in boundary length
        [Ashell, Bshell, newBoundary, newBL] = extract_boundary(newRegionA,newRegionB);
        BL_change = abs(newBL-BL);
        
        %Test new value for acceptance
        accept = false;
        if newBL<BL
            
            accept = true;
            
        else
            
            if (i==1 && j==1)
                avg_BL_change = BL_change;
            end
        
            %Probability to accept worse value
            p = P(avg_BL_change,BL_change,T);
            if rand()<p
                accept = true;
            end
            
        end
        
        
        %If new boundary is accepted, update values
        if accept
            
            numAccepted = numAccepted + 1;
            
            regionA = newRegionA;
            regionA_IDs = unique(gIDmat(regionA));
            regionB = newRegionB;
            regionB_IDs = unique(gIDmat(regionB));
            
            boundaryA_IDs = regionA_IDs(ismember(regionA_IDs,gIDmat(newBoundary)));
            boundaryA_IDs = boundaryA_IDs(ismember(boundaryA_IDs,commonRegion_IDs));
            boundaryB_IDs = regionB_IDs(ismember(regionB_IDs,gIDmat(newBoundary)));
            boundaryB_IDs = boundaryB_IDs(ismember(boundaryB_IDs,commonRegion_IDs));

            BL = newBL;
            
            if BL<bestResultBL
                bestResultBL = BL;
                bestResultA = regionA;
                bestResultB = regionB;
            end
            
            %Update average change in boundary length
            avg_BL_change = (avg_BL_change*(numAccepted-1) + BL_change)/numAccepted;
            
        end
        
    end
    
    %Increment T
    T = frac*T;

end

update_clusters(gIDmat,clusterA,clusterB,bestResultA,bestResultB);

end

function update_clusters(gIDmat,clusterA,clusterB,regionA_result,regionB_result)

    global reconstructor

    %Change clusterA to reflect reassignments
    AfinalGrains = unique(gIDmat(regionA_result));
    AMembersToMove = ~ismember([clusterA.memberGrains.OIMgid],AfinalGrains);
    AIncludedNonMembersToMove = ~ismember([clusterA.includedNonMemberGrains.OIMgid],AfinalGrains);
    if any(AMembersToMove)
        clusterA.inactiveGrains = union(clusterA.inactiveGrains,clusterA.memberGrains(AMembersToMove));
        clusterA.memberGrains = clusterA.memberGrains(~AMembersToMove);
    end

    if any(AIncludedNonMembersToMove)
        clusterA.inactiveGrains = union(clusterA.inactiveGrains,clusterA.includedNonMemberGrains(AIncludedNonMembersToMove));
        clusterA.includedNonMemberGrains = clusterA.includedNonMemberGrains(~AIncludedNonMembersToMove);
    end
    clusterA.calc_metadata(reconstructor.grainmap.gIDmat,'filled');

    %Change clusterB to reflect reassignments
    BfinalGrains = unique(gIDmat(regionB_result));
    BMembersToMove = ~ismember([clusterB.memberGrains.OIMgid],BfinalGrains);
    BIncludedNonMembersToMove = ~ismember([clusterB.includedNonMemberGrains.OIMgid],BfinalGrains);
    if any(BMembersToMove)
        clusterB.inactiveGrains = union(clusterB.inactiveGrains,clusterB.memberGrains(BMembersToMove));
        clusterB.memberGrains = clusterB.memberGrains(~BMembersToMove);
    end

    if any(BIncludedNonMembersToMove)
        clusterB.inactiveGrains = union(clusterB.inactiveGrains,clusterB.includedNonMemberGrains(BIncludedNonMembersToMove));
        clusterB.includedNonMemberGrains = clusterB.includedNonMemberGrains(~BIncludedNonMembersToMove);
    end
    clusterB.calc_metadata(reconstructor.grainmap.gIDmat,'filled');

end

function flipID = next_trial(boundaryA_IDs,boundaryB_IDs)

    list = [boundaryA_IDs(:)' boundaryB_IDs(:)'];
    flipID = list(randi(length(list)));

end

function p = P(avg_dE,dE,T)
    
    p = exp(-dE/(avg_dE*T));

end