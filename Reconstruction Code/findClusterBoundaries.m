gIDmat = testgrainmap.gIDmat;
clusters = testreconstructor.clusters;

[r,c] = size(gIDmat);
clustermap = cell(r,c);

%Cycle through each cluster and add cluster ID at each scan location it
%covers
for i=1:length(clusters)
    
    currClust = clusters{i};
    memberGrainIDs = [currClust.memberGrains.OIMgid];
    interiorIDs = currClust.interiorNonMemberGrainIDs;
    compIDs = [memberGrainIDs interiorIDs(:)'];
    
    memberLocs = ismember(gIDmat,compIDs);
    
    clustermap(memberLocs) = cellfun(@(x) [x i], clustermap(memberLocs),'UniformOutput',false);
    
end

%Cycle through each pixel of the scan, making each pair of pixels that
%represents a boundary between exclusive sets of clusters claiming those
%pixels
boundaries = ones(r,c);

%first cycle through rows
for i=1:r
    for j=1:c-1
        %compare current pixel with pixel to the right. If the sets of
        %cluster IDs for both pixels are mutually exclusive, then mark both 
        %as a boundary
        pixel1clusters = clustermap{i,j};
        pixel2clusters = clustermap{i,j+1};
        
        if ~any(intersect(pixel1clusters,pixel2clusters))
            boundaries(i,j) = 0;
            boundaries(i,j+1) = 0;
        end
        
    end
end

%cycle through columns
for j=1:c
    for i=1:r-1
        %compare current pixel with pixel to the right. If the sets of
        %cluster IDs for both pixels are mutually exclusive, then mark both 
        %as a boundary
        pixel1clusters = clustermap{i,j};
        pixel2clusters = clustermap{i+1,j};
        
        if ~any(intersect(pixel1clusters,pixel2clusters))
            boundaries(i,j) = 0;
            boundaries(i+1,j) = 0;
        end
        
    end
end

figure(2);
imshow(boundaries);

%%

%Perform watershed segmentation
bw = boundaries;
D = bwdist(~bw);
figure
imshow(D,[],'InitialMagnification','fit')
title('Distance transform of ~bw')

D = -D;
D(~bw) = -Inf;

% I2 = imcomplement(D);
I2 = D;
I3 = imhmin(I2,10); %20 is the height threshold for suppressing shallow minima
L = watershed(I3);

% L = watershed(D);
rgb = label2rgb(L,'jet',[.5 .5 .5]);
figure
imshow(rgb,'InitialMagnification','fit')
title('Watershed transform of D')



