currClust = testreconstructor.clusters{1};

PAGmat = currClust.clusterOCenter.g;
PAQ = currClust.clusterOCenter.quat;

memberO = [currClust.memberGrains.orientation];
% memberO = [currClust.theoreticalVariants];


memberPAQ = [currClust.parentPhaseOrientations.quat];

PAmisos = q_min_distfun(PAQ',memberPAQ','cubic');

gammaPlanes = [1 1 1; -1 1 1; 1 -1 1; 1 1 -1]/sqrt(3);
alphaPlanes = [1 1 0; 1 0 1; 0 1 1; -1 1 0; -1 0 1; 0 -1 1]'/sqrt(2);

minAngles = zeros(1,length(memberO));
for i=1:length(memberO)
    
    currGmat = memberO(i).g;
    
    AtoGmat = PAGmat*currGmat';
    
    alphaPlanesGammaFrame = AtoGmat*alphaPlanes;
    
    dotProducts = gammaPlanes*alphaPlanesGammaFrame;
    
    angles = acos(dotProducts);
    toShift = angles>(pi/2);
    angles(toShift) = pi-angles(toShift);
    
    minAngles(i) = min(min(angles));
    
    
    
end

figure;
hist(PAmisos*180/pi);
figure;
hist(minAngles*180/pi);