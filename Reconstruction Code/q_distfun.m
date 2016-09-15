%function to get the distance (misorientation) of quaternion XI (row 
%vector) from quaternions XJ (multiple row vectors)

%This does not consider any form of symmetry in the set of orientations

function d2 = q_distfun(XI,XJ)

cosines = XJ*XI';
d2 = 2*acos(cosines);

end