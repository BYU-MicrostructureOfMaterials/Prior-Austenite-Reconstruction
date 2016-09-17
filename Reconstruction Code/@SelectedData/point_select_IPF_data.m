function IDs = point_select_IPF_data(I, id_mat)

[nrowsI,ncolsI] = size(I(:,:,1));
[nrowsMat,ncolsMat] = size(id_mat);

if nrowsI~=nrowsMat || ncolsI~=ncolsMat
    error('Input image and ID matrix are not the same size');
end

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
        
        plot(xset,yset,'k*','MarkerSize',5);
    end
    
end

xset = int32(xset);
yset = int32(yset);

Linds = sub2ind([nrowsI ncolsI],yset,xset);

IDs = setdiff(unique(id_mat(Linds)),0);

end