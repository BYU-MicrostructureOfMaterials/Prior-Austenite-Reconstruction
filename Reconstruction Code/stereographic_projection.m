%needed features
%--write function description, describing projection geometry used
%make code more readable with comments

function [X, Y] = stereographic_projection(vector)

projection = [0 0 -1] - vector';
projection = projection/norm(projection);
angle = acos(dot(projection,[0 0 -1]));
length = tan(angle);
xydir = [vector(1) vector(2) 0];
if norm(xydir)~=0
    xydir = xydir/norm(xydir);
end

xypos = length*xydir;
X = xypos(1);
Y = xypos(2);
    
end