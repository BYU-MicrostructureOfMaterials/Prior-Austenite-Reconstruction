%Input RF vectors as column vectors
%Needs to be generalized to automatically choose figure numbers

function [] = plot_RF_FZc(R,q,markerstring,mark_size,figh)

oct_facet_dist = tan(pi/8);
tri_facet_dist = tan(pi/6);
b = [oct_facet_dist oct_facet_dist tri_facet_dist]';
figure(figh);
axis equal;
hold on;

%planes perpendicular to [100] directions
pXplane = [1 0 0];
pYplane = [0 1 0];
pZplane = [0 0 1];
nXplane = [-1 0 0];
nYplane = [0 -1 0];
nZplane = [0 0 -1];

%planes perpendicular to [111] directions
ppp = (1/sqrt(3))*[1 1 1];
npp = (1/sqrt(3))*[-1 1 1];
nnp = (1/sqrt(3))*[-1 -1 1];
pnp = (1/sqrt(3))*[1 -1 1];
ppn = (1/sqrt(3))*[1 1 -1];
npn = (1/sqrt(3))*[-1 1 -1];
nnn = (1/sqrt(3))*[-1 -1 -1];
pnn = (1/sqrt(3))*[1 -1 -1];

%intersection of (111) plane with {100} planes, plot triangular facet
p1 = [pXplane; pZplane; ppp]\b;
p2 = [pXplane; pYplane; ppp]\b;
p3 = [pYplane; pZplane; ppp]\b;
plot3([p1(1) p2(1) p3(1) p1(1)],[p1(2) p2(2) p3(2) p1(2)],[p1(3) p2(3) p3(3) p1(3)],'b');

%intersection of (-111) plane with {100} planes, plot triangular facet
p1 = [nXplane; pZplane; npp]\b;
p2 = [nXplane; pYplane; npp]\b;
p3 = [pYplane; pZplane; npp]\b;
plot3([p1(1) p2(1) p3(1) p1(1)],[p1(2) p2(2) p3(2) p1(2)],[p1(3) p2(3) p3(3) p1(3)],'b');

%intersection of (-1-11) plane with {100} planes, plot triangular facet
p1 = [nXplane; pZplane; nnp]\b;
p2 = [nXplane; nYplane; nnp]\b;
p3 = [nYplane; pZplane; nnp]\b;
plot3([p1(1) p2(1) p3(1) p1(1)],[p1(2) p2(2) p3(2) p1(2)],[p1(3) p2(3) p3(3) p1(3)],'b');

%intersection of (1-11) plane with {100} planes, plot triangular facet
p1 = [pXplane; pZplane; pnp]\b;
p2 = [pXplane; nYplane; pnp]\b;
p3 = [nYplane; pZplane; pnp]\b;
plot3([p1(1) p2(1) p3(1) p1(1)],[p1(2) p2(2) p3(2) p1(2)],[p1(3) p2(3) p3(3) p1(3)],'b');

%intersection of (11-1) plane with {100} planes, plot triangular facet
p1 = [pXplane; nZplane; ppn]\b;
p2 = [pXplane; pYplane; ppn]\b;
p3 = [pYplane; nZplane; ppn]\b;
plot3([p1(1) p2(1) p3(1) p1(1)],[p1(2) p2(2) p3(2) p1(2)],[p1(3) p2(3) p3(3) p1(3)],'b');

%intersection of (-11-1) plane with {100} planes, plot triangular facet
p1 = [nXplane; nZplane; npn]\b;
p2 = [nXplane; pYplane; npn]\b;
p3 = [pYplane; nZplane; npn]\b;
plot3([p1(1) p2(1) p3(1) p1(1)],[p1(2) p2(2) p3(2) p1(2)],[p1(3) p2(3) p3(3) p1(3)],'b');

%intersection of (-1-1-1) plane with {100} planes, plot triangular facet
p1 = [nXplane; nZplane; nnn]\b;
p2 = [nXplane; nYplane; nnn]\b;
p3 = [nYplane; nZplane; nnn]\b;
plot3([p1(1) p2(1) p3(1) p1(1)],[p1(2) p2(2) p3(2) p1(2)],[p1(3) p2(3) p3(3) p1(3)],'b');

%intersection of (1-1-1) plane with {100} planes, plot triangular facet
p1 = [pXplane; nZplane; pnn]\b;
p2 = [pXplane; nYplane; pnn]\b;
p3 = [nYplane; nZplane; pnn]\b;
plot3([p1(1) p2(1) p3(1) p1(1)],[p1(2) p2(2) p3(2) p1(2)],[p1(3) p2(3) p3(3) p1(3)],'b');

%connecting lines for octahedral facets:
p1 = [pXplane; pZplane; ppp]\b;
p2 = [pXplane; pZplane; pnp]\b;
plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b');

p1 = [pYplane; pZplane; ppp]\b;
p2 = [pYplane; pZplane; npp]\b;
plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b');

p1 = [nXplane; pZplane; npp]\b;
p2 = [nXplane; pZplane; nnp]\b;
plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b');

p1 = [nYplane; pZplane; nnp]\b;
p2 = [nYplane; pZplane; pnp]\b;
plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b');

p1 = [pXplane; nZplane; ppn]\b;
p2 = [pXplane; nZplane; pnn]\b;
plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b');

p1 = [pYplane; nZplane; ppn]\b;
p2 = [pYplane; nZplane; npn]\b;
plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b');

p1 = [nXplane; nZplane; npn]\b;
p2 = [nXplane; nZplane; nnn]\b;
plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b');

p1 = [nYplane; nZplane; nnn]\b;
p2 = [nYplane; nZplane; pnn]\b;
plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b');

p1 = [pXplane; pYplane; ppp]\b;
p2 = [pXplane; pYplane; ppn]\b;
plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b');

p1 = [pXplane; nYplane; pnp]\b;
p2 = [pXplane; nYplane; pnn]\b;
plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b');

p1 = [nXplane; nYplane; nnp]\b;
p2 = [nXplane; nYplane; nnn]\b;
plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b');

p1 = [nXplane; pYplane; npp]\b;
p2 = [nXplane; pYplane; npn]\b;
plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b');

%--------------------------------------------------------------------------
if isempty(R) && ~isempty(q)
    load qpos_symops_mat;
    R = quat2fundRF(q,qpos_symops_mat);
%     R = quat2RF(q);
end

X = R(1,:);
Y = R(2,:);
Z = R(3,:);

plot3(X,Y,Z,markerstring,'MarkerSize',mark_size);


end