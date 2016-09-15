%Must be at least a 3x3 image
function filledBW = region_fill_holes(BW,connectivity)

%Pad array
[nrows,ncols] = size(BW);
paddedBW = BW;
paddedBW = [true(nrows,1) paddedBW true(nrows,1)];
paddedBW = [true(1,ncols+2); paddedBW; true(1,ncols+2)];

[nPadRows,nPadCols] = size(paddedBW);
inversePaddedBW = ~paddedBW;

interiorMaskedBW = paddedBW;
interiorMaskedBW(3:nPadRows-2,3:nPadCols-2) = true;
[r,c] = find(~interiorMaskedBW);

Linds = sub2ind([nPadRows nPadCols],r,c)';

%Flood-fill all pixels from the edge in, leaving just interior holes
groupInds = [];
toCheck = Linds;

while ~isempty(toCheck)

    groupInds = [groupInds toCheck];

    inds = [];
    for i=1:length(toCheck)
        currInd = toCheck(i);
        inds = [inds check_neighbors(currInd,inversePaddedBW,connectivity,nPadRows)];
    end

    inds = unique(inds);
    inds = inds(~ismember(inds,groupInds));
    toCheck = inds;

end

edgeFloodedBW = paddedBW;
edgeFloodedBW(groupInds) = true;

filledBW = paddedBW;
filledBW(~edgeFloodedBW) = true;
filledBW = filledBW(2:nPadRows-1,2:nPadCols-1);

end

%BW matrix must be padded with zeros or this function will attempt to
%access indices out of bounds
function passedNeighbors = check_neighbors(ind,BW,connectivity,nrows)

passedNeighbors = [];
if connectivity==4 || connectivity==8
    neighbors = [ind-1 ind+1 ind-nrows ind+nrows];
    passedNeighbors = neighbors(BW(neighbors));
end

if connectivity==8
    neighbors = [ind-nrows-1 ind+nrows-1 ind-nrows+1 ind+nrows+1];
    passedNeighbors = [passedNeighbors neighbors(BW(neighbors))];
end

end