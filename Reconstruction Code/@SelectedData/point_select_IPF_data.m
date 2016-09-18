function IDs = point_select_IPF_data(I, reconstructor,type)

switch type
    case 'PA'
        id_mat = reconstructor.clusterIDmat;
        image = reconstructor.reconstructedIPFmap.IPFimage;
    case 'daughterGrains'
        id_mat = reconstructor.grainmap.gIDmat;
        image = reconstructor.grainmap.grainIPFmap.IPFimage;
end

axes(I);
hold on;

[nrowsMat,ncolsMat] = size(id_mat);

xset = [];
yset = [];

pickAnother = true;
while pickAnother
   
    pickAnother = true;
    
    [x,y,button] = ginput(1);
    
    if isempty(button) || ~ismember(button,[1 2 3])
        imshow(image);
        pickAnother = false;
    else
        xset = [xset; x];
        yset = [yset; y];
        
        plot(xset,yset,'k*','MarkerSize',5);
    end
    
end

xset = int32(xset);
yset = int32(yset);

Linds = sub2ind([nrowsMat ncolsMat],yset,xset);

IDs = setdiff(unique(id_mat(Linds)),0);

end