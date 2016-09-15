gIDmat = testgrainmap.gIDmat;
[r,c] = size(gIDmat);

%filter gIDmat to only contain gIDs of grains that are the correct phase
includedIDs = [testreconstructor.daughterGrains.OIMgid];
includedMat = ismember(gIDmat,includedIDs);
gIDmat(~includedMat)=0;

grainPool = testreconstructor.daughterGrains;
boundaryMisos = zeros(r,c);

%cycle through roww
for i=1:r
    for j=1:c-1
        pix1GID = gIDmat(i,j);
        pix2GID = gIDmat(i,j+1);
        
        if pix1GID~=pix2GID && pix1GID~=0 && pix2GID~=0
            
            pix1PAO = grainPool(pix1GID).newPhaseOrientations;
            pix2PAO = grainPool(pix2GID).newPhaseOrientations;
            
            pix1PAq = [pix1PAO.quat];
            pix2PAq = [pix2PAO.quat];
            
            misos = zeros(length(pix2PAq(1,:)),length(pix1PAq(1,:)));
            for k=1:length(pix1PAq(1,:))
                misos(:,k) = q_min_distfun(pix1PAq(:,k)',pix2PAq','cubic');
            end
            
            minMiso = min(min(misos));
            boundaryMisos(i,j) = minMiso;
            boundaryMisos(i,j+1) = minMiso;
        
        end
    end
end

%cycle throug columns
for j=1:c
    for i=1:r-1
        pix1GID = gIDmat(i,j);
        pix2GID = gIDmat(i+1,j);
        
        if pix1GID~=pix2GID && pix1GID~=0 && pix2GID~=0
            
            pix1PAO = grainPool(pix1GID).newPhaseOrientations;
            pix2PAO = grainPool(pix2GID).newPhaseOrientations;
            
            pix1PAq = [pix1PAO.quat];
            pix2PAq = [pix2PAO.quat];
            
            misos = zeros(length(pix2PAq(1,:)),length(pix1PAq(1,:)));
            for k=1:length(pix1PAq(1,:))
                misos(:,k) = q_min_distfun(pix1PAq(:,k)',pix2PAq','cubic');
            end
            
            minMiso = min(min(misos));
            boundaryMisos(i,j) = minMiso;
            boundaryMisos(i+1,j) = minMiso;
        
        end
    end
end

%set all locations where gIDmat=0 to Inf

% I3 = imhmin(boundaryMisos,20); %20 is the height threshold for suppressing shallow minima
% L = watershed(I3);




