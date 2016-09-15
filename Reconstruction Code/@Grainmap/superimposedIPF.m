function superimposedIPF(obj,type)

disp('here');

IPFmap = obj.grainIPFmap.IPFimage;

switch type
    
    case 'IQ'
        IPFmap(:,:,1) = IPFmap(:,:,1).*obj.IQmat;
        IPFmap(:,:,2) = IPFmap(:,:,2).*obj.IQmat;
        IPFmap(:,:,3) = IPFmap(:,:,3).*obj.IQmat;
        
    case 'CI'
        IPFmap(:,:,1) = IPFmap(:,:,1).*obj.CImat;
        IPFmap(:,:,2) = IPFmap(:,:,2).*obj.CImat;
        IPFmap(:,:,3) = IPFmap(:,:,3).*obj.CImat;
        
end

figure;

imshow(IPFmap);

end