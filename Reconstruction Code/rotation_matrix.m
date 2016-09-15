function rotmat = rotation_matrix(axis,theta)

%Creates rotation matrix to rotate a vector by the angle theta about the
%given axis

%All vectors and axes are in same coordinate frame

% theta = theta * (pi/180);

axis = axis/norm(axis);
ux = axis(1);
uy = axis(2);
uz = axis(3);

rotmat = [cos(theta)+(ux^2)*(1-cos(theta)) ux*uy*(1-cos(theta))-uz*sin(theta) ux*uz*(1-cos(theta))+uy*sin(theta);...
         uy*ux*(1-cos(theta))+uz*sin(theta) cos(theta)+uy*uy*(1-cos(theta)) uy*uz*(1-cos(theta))-ux*sin(theta);...
         uz*ux*(1-cos(theta))-uy*sin(theta) uz*uy*(1-cos(theta))+ux*sin(theta) cos(theta)+uz*uz*(1-cos(theta))];