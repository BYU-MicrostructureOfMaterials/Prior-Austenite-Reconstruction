clusterA = testreconstructor.clusters([testreconstructor.clusters.ID]==10);
clusterB = testreconstructor.clusters([testreconstructor.clusters.ID]==94);

% clusterB.calc_metadata(testgrainmap.gIDmat,'membersOnly');


%%
bw = test2;%clusterB.scanLocations;

s = regionprops(bw, 'Orientation', 'MajorAxisLength','MinorAxisLength', 'Eccentricity', 'Centroid');

figure(1);
% imshow(clusterB.clusterIPFmap.IPFimage);
imshow(bw)
hold on

phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);

for k = 1:length(s)
    xbar = s(k).Centroid(1);
    ybar = s(k).Centroid(2);

    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;

    theta = pi*s(k).Orientation/180;
    R = [ cos(theta)   sin(theta)
         -sin(theta)   cos(theta)];

    xy = [a*cosphi; b*sinphi];
    xy = R*xy;

    x = xy(1,:) + xbar;
    y = xy(2,:) + ybar;

    plot(x,y,'r','LineWidth',2);
end
hold off

%%

MajAngle = s.Orientation;
MajAngle = MajAngle*pi/180;

rotmat = rotation_matrix([0 0 1],MajAngle);
plane_norm = rotmat*[1; 0; 0];
boundary_vect = rotmat*[0; 1; 0];

load quat_cubic_symops;

for i=1:24
    Asym = quatLmult(quat_cubic_symops(:,i),clusterA.clusterOCenter.quat);
    for j=1:24
        Bsym = quatLmult(quat_cubic_symops(:,j),clusterB.clusterOCenter.quat);
        misos(i,j) = q_distfun(Asym',Bsym');
    end
end
misos = misos*180/pi;
misos = abs(misos-60);
closeMisos = misos<1;
[r,c] = find(closeMisos);

%choose symmetries
Aquat = quatLmult(quat_cubic_symops(:,r(1)),clusterA.clusterOCenter.quat);
Bquat = quatLmult(quat_cubic_symops(:,c(1)),clusterB.clusterOCenter.quat);

misoQuat = quatLmult(Bquat,[-Aquat(1) -Aquat(2) -Aquat(3) Aquat(4)]);
axis = [misoQuat(1) misoQuat(2) misoQuat(3)];
axis = axis/norm(axis);

angle = 2*acos(misoQuat(4))*180/pi;

clustPlanes = [1 1 1; -1 1 1; 1 -1 1; 1 1 -1]/sqrt(3);

Aplanes = Orientation.quat2gmat(Aquat)'*clustPlanes';
Bplanes = Orientation.quat2gmat(Bquat)'*clustPlanes';

%manually extract which planes are parallel
chosenA = Aplanes(:,2);
chosenB = Bplanes(:,2);


            
