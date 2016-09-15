%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% g = euler2gmat(phi1,PHI,phi2)
%
% Brigham Young University 2016
%
% Inputs: Proper Euler rotation angles for passive rotation, ZXZ convention
% phi1 - Rotation about Z axis, in radians
% PHI  - Rotation about X' axis, in radians
% phi2 - Rotation about Z'' axis, in radians
%
% Output: 3X3 passive rotation matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [g]=euler2gmat(phi1,PHI,phi2)

cp1 = cos(phi1);
sp1 = sin(phi1);
cp2 = cos(phi2);
sp2 = sin(phi2);
cP  = cos(PHI);
sP  = sin(PHI);
g=zeros(3,3);
g(1,1)= cp1.*cp2-sp1.*sp2.*cP;
g(1,2) = sp1.*cp2+cp1.*sp2.*cP;
g(1,3) = sp2.*sP;
g(2,1)= -cp1.*sp2-sp1.*cp2.*cP;
g(2,2)= -sp1.*sp2+cp1.*cp2.*cP;
g(2,3)= cp2.*sP;
g(3,1)=  sp1.*sP;
g(3,2)= -cp1.*sP;
g(3,3)=  cP;