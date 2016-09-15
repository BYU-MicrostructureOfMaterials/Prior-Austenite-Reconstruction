function IDs = region_label(BW,connectivity)

%Pad array
[nrows,ncols] = size(BW);
paddedBW = BW;
paddedBW = [false(nrows,1) paddedBW false(nrows,1)];
paddedBW = [false(1,ncols+2); paddedBW; false(1,ncols+2)];

[nPadRows,nPadCols] = size(paddedBW);
IDs = zeros(nPadRows,nPadCols);

Linds = find(paddedBW);
currID = 1;
while ~isempty(Linds) 
    
    start = Linds(1);
    groupInds = start;
    toCheck = check_neighbors(start,paddedBW,connectivity,nPadRows);
    
    while ~isempty(toCheck)
        
        groupInds = [groupInds toCheck];
        
        inds = [];
        for i=1:length(toCheck)
            currInd = toCheck(i);
            inds = [inds check_neighbors(currInd,paddedBW,connectivity,nPadRows)];
        end
        
%         inds = setdiff(unique(inds),groupInds);
        inds = unique(inds);
        inds = inds(~ismember(inds,groupInds));
        toCheck = inds;
    
    end
    
%     Linds = setdiff(Linds,groupInds);
    Linds = Linds(~ismember(Linds,groupInds));
    IDs(groupInds) = currID;
    currID = currID + 1;
    
end

IDs = IDs(2:nPadRows-1,2:nPadCols-1);

end

function passedNeighbors = check_neighbors(ind,paddedBW,connectivity,nPadRows)

passedNeighbors = [];
if connectivity==4 || connectivity==8
    neighbors = [ind-1 ind+1 ind-nPadRows ind+nPadRows];
    passedNeighbors = neighbors(paddedBW(neighbors));
end

if connectivity==8
    neighbors = [ind-nPadRows-1 ind+nPadRows-1 ind-nPadRows+1 ind+nPadRows+1];
    passedNeighbors = [passedNeighbors neighbors(paddedBW(neighbors))];
end

end
