%function to get the distance (misorientation) of quaternion XI (row 
%vector) from quaternions XJ (multiple row vectors)

%output minimum misos as column vector d2

function d2 = q_min_distfun(XI,XJ,ST)

switch ST

    case 'cubic'
        XI = XI';
        XJ = XJ';

        inv_XJ = XJ;
        inv_XJ(1:3,:) = -1*inv_XJ(1:3,:);
        
        XImat =[XI(4) -XI(3) XI(2) XI(1);...
                XI(3) XI(4) -XI(1) XI(2);...
                -XI(2) XI(1) XI(4) XI(3);...
                -XI(1) -XI(2) -XI(3) XI(4)];
        

        miso_quats = XImat*inv_XJ;
        D = sort(abs(miso_quats));

        comp_vects = [D(4,:); (D(4,:)+D(3,:))/sqrt(2); sum(D)/2];
        max_cosines = max(comp_vects);

        d2 = 2*acos(max_cosines)';
        
    case 'other'
        
end

end