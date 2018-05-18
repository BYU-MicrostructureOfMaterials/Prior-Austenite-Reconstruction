function [BW,IDs] = poly_select_IPF_data(I, reconstructor, type, show)

switch type
    case 'PA'
        id_mat = reconstructor.clusterIDmat;
        image = reconstructor.reconstructedIPFmap.IPFimage;
    case 'daughterGrains'
        id_mat = reconstructor.grainmap.gIDmat;
        image = reconstructor.grainmap.grainIPFmap.IPFimage;
end

[nrowsMat,ncolsMat] = size(id_mat);

BW = false(nrowsMat,ncolsMat);

[X,Y] = meshgrid(1:ncolsMat,1:nrowsMat);
X = X(:);
Y = Y(:);

axes(I);
hold on;

xset = [];
yset = [];

pickAnother = true;
while pickAnother
   
    pickAnother = true;
    
    [x,y,button] = ginput(1);
    
    if isempty(button) || ~ismember(button,[1 2 3])
        if(show == true || nargin == 3)
            imshow(image);
        end
        pickAnother = false;
    else
        xset = [xset; x];
        yset = [yset; y];
        
        plot(xset,yset,'w','LineWidth',1);
    end
    
end

[in,on] = inpolygon(X,Y,xset,yset);

X = X(and(in,~on));
Y = Y(and(in,~on));

Linds = sub2ind([nrowsMat ncolsMat],Y,X);

BW(Linds) = true;
IDs = setdiff(unique(id_mat(BW)),0);

end