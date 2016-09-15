%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Stephen Cluff
%   5/23/2014
%   This function plots 2d and 3d <100> pole figures from orientation data. 
%    Input orientations are rotation matrices assumed to be PASSIVE 
%    rotations.
%
%   Inputs:
%   gmats - 3x3xN array of passive rotation matrices
%   markerstring - MATLAB plot format string defining type of points
%                  plotted (i.e. 'bd' for blue diamonds)
%   mark_size - integer specifying marker size in plot
%   fignum2D - figure number to plot 2D pole figure
%   include3D - true/false use true to plot pole data on a sphere
%   fignum3D - figure number to plot 3D pole data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = pole_figure_by_gmat(gmats,markerstring,mark_size,fignum2D,include3D,fignum3D)

%create pole figure data
for i=1:length(gmats(1,1,:))

    %get g from sample to crystal
    StoC = gmats(:,:,i);

    %define crystal basis in global csys by using inverse of StoC
    cx = StoC\[1 0 0]';
    cy = StoC\[0 1 0]';
    cz = StoC\[0 0 1]';

    %generate data for 3d pole figure
    cxu(i) = cx(1); cxv(i) = cx(2); cxw(i) = cx(3); %crystal x axis' global (u,v,w) components
    cyu(i) = cy(1); cyv(i) = cy(2); cyw(i) = cy(3); %crystal y axis' global (u,v,w) components
    czu(i) = cz(1); czv(i) = cz(2); czw(i) = cz(3); %crystal z axis' global (u,v,w) components


    % generate data for 2d pole figure
    tol = 1e-10; %math creates very small numbers, some introducing false negatives
    if abs(cx(3))<tol, cx(3)=0; end
    if abs(cy(3))<tol, cy(3)=0; end
    if abs(cz(3))<tol, cz(3)=0; end

    %if z component of any vector is negative, plot the negative of
    %that axis instead so it intersects with the upper hemisphere in
    %the pole figure
    if cx(3)<0, cx=-1*cx; end
    if cy(3)<0, cy=-1*cy; end
    if cz(3)<0, cz=-1*cz; end

    %find stereographic projection of each axis and plot
    [cxX(i), cxY(i)] = stereographic_projection(cx); %crystal x axis' (X,Y) components for pole figure plot
    [cyX(i), cyY(i)] = stereographic_projection(cy); %crystal y axis' (X,Y) components for pole figure plot
    [czX(i), czY(i)] = stereographic_projection(cz); %crystal z axis' (X,Y) components for pole figure plot

end

%create pole figure plot
fig1 = figure(fignum2D);
hold on;
axis equal;
whitebg(fig1,'white');
theta = 0:.001:2*pi;
x = cos(theta);
y = sin(theta);
plot(x,y,'k');
x = -1:.001:1;
y = zeros(1,length(x));
plot(x,y,'k');
y = -1:.001:1;
x = zeros(1,length(y));
plot(x,y,'k');

plot(-cxY,cxX,markerstring,'MarkerSize',mark_size); %Rotate so that X is up and Y is left to match OIM analysis
plot(-cyY,cyX,markerstring,'MarkerSize',mark_size);
plot(-czY,czX,markerstring,'MarkerSize',mark_size);

%create 3d pole figure plot
if include3D

    fig2 = figure(fignum3D);
    hold on;
    whitebg(fig2,[.5 .5 .5]);
    [X, Y, Z] = sphere(30);
    rad = .99;  %set to be slightly less than 1 so as to show the points plotted on the sphere.
    h =surf(rad*X,rad*Y,rad*Z);
    axis equal;
    set(h,'EdgeColor','white');
    set(h,'FaceColor','white');

    x = .75:.001:1.5;
    y = zeros(length(x));
    z = zeros(length(x));
    plot3(x,y,z,'b');

    y = .75:.001:1.5;
    x = zeros(length(y));
    z = zeros(length(y));
    plot3(x,y,z,'r');

    z = .75:.001:1.5;
    x = zeros(length(z));
    y = zeros(length(z));
    plot3(x,y,z,'g');

    plot3(cxu,cxv,cxw,markerstring,'MarkerSize',mark_size);
    plot3(cyu,cyv,cyw,markerstring,'MarkerSize',mark_size);
    plot3(czu,czv,czw,markerstring,'MarkerSize',mark_size);

    xlabel('X');
    ylabel('Y');
    zlabel('Z');

end

end



