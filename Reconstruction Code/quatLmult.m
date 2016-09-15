%Left multiply qA by qB, i.e. Q = qA*qB where * is quaternion product
%Represents rotation qB followed by rotation qA
%This assumes form of quaternion = [qx,qy,qz,qw] (real value is last)

%qB can be multiple orientations, all left multiplied by qA.
%If multiple quaternions are input for qB, quaternions are assumed to be
%input as column vectors

%Output Q is either single column quaternion or multiple, depending on
%input for qB

function Q = quatLmult(qA,qB)

qAmat = [qA(4) -qA(3) qA(2) qA(1);
         qA(3) qA(4) -qA(1) qA(2);
        -qA(2) qA(1) qA(4) qA(3);
        -qA(1) -qA(2) -qA(3) qA(4)];
    
if numel(qB)== 4
    Q = qAmat*qB(:);
elseif size(qB,1)==4
    Q = qAmat*qB;
elseif size(qB,2)==4
    Q = qAmat*qB';
else
    error('Input value qB dimensions inconsistent with quaternion multiplication');
end

end