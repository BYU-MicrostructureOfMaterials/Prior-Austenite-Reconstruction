function [Ashell, Bshell, boundary_locs, BL] = extract_boundary(maskA,maskB)

if nargin>0
    
    %Pad boundaries
    [nrows,ncols] = size(maskA);
    paddedMaskA = maskA;
    paddedMaskA = [false(nrows,1) paddedMaskA false(nrows,1)];
    paddedMaskA = [false(1,ncols+2); paddedMaskA; false(1,ncols+2)];

    Ashell = circshift(paddedMaskA,[0 -1])+...
                circshift(paddedMaskA,[-1 -1])+...
                circshift(paddedMaskA,[-1 0])+...
                circshift(paddedMaskA,[-1 1])+...
                circshift(paddedMaskA,[0 1])+...
                circshift(paddedMaskA,[1 1])+...
                circshift(paddedMaskA,[1 0])+...
                circshift(paddedMaskA,[1 -1]);
                
    Ashell = logical(Ashell);
    Ashell = and(Ashell,~paddedMaskA);
    Ashell = Ashell(2:nrows+1,2:ncols+1);
    
else
    
    error('Incorrect number of input arguments');
    
end

if nargin==2
    
    if any(size(maskA)~=size(maskB))
        error('Input BW matrices must be the same size');
    end
    
    if any(any(and(maskA,maskB)))
        error('Regions overlap - regions must be mutually exclusive');
    end
    
    paddedMaskB = maskB;
    paddedMaskB = [false(nrows,1) paddedMaskB false(nrows,1)];
    paddedMaskB = [false(1,ncols+2); paddedMaskB; false(1,ncols+2)];
    
    Bshell = circshift(paddedMaskB,[0 -1])+...
                circshift(paddedMaskB,[-1 -1])+...
                circshift(paddedMaskB,[-1 0])+...
                circshift(paddedMaskB,[-1 1])+...
                circshift(paddedMaskB,[0 1])+...
                circshift(paddedMaskB,[1 1])+...
                circshift(paddedMaskB,[1 0])+...
                circshift(paddedMaskB,[1 -1]);
                
    Bshell = logical(Bshell);
    Bshell = and(Bshell,~paddedMaskB);
    Bshell = Bshell(2:nrows+1,2:ncols+1);
    
    boundary_locs = or(and(Ashell,maskB),and(Bshell,maskA));

    BL = sum(sum(boundary_locs))/2;

end

if nargin>2
    
    error('Incorrect number of input arguments');
    
end
    
end