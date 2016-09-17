function [BW,IDs] = poly_select_IPF_data(I, id_mat)

[nrowsI,ncolsI] = size(I(:,:,1));
[nrowsMat,ncolsMat] = size(id_mat);

if nrowsI~=nrowsMat || ncolsI~=ncolsMat
    error('Input image and ID matrix are not the same size');
end

BW = false(nrowsI,ncolsI);

[X,Y] = meshgrid(1:ncolsI,1:nrowsI);
X = X(:);
Y = Y(:);

figure;
imshow(I);
hold on;

xset = [];
yset = [];

pickAnother = true;
while pickAnother
   
    pickAnother = true;
    
    [x,y,button] = ginput(1);
    
    if isempty(button) || ~ismember(button,[1 2 3])
        imshow(I);
        pickAnother = false;
    else
        xset = [xset; x];
        yset = [yset; y];
        
        plot(xset,yset,'k','LineWidth',1);
    end
    
end

[in,on] = inpolygon(X,Y,xset,yset);

X = X(and(in,~on));
Y = Y(and(in,~on));

Linds = sub2ind([nrowsI ncolsI],Y,X);

BW(Linds) = true;
IDs = setdiff(unique(id_mat(BW)),0);

end