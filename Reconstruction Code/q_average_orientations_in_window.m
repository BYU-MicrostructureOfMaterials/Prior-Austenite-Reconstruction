%Input orientations to average should be previously found to have a minimum
%misorientation within the given window, found using q_min_distfun.

%Generate all symmetries of each orientation, and both + and - quaternions.
%Using q_distfun, choose the quaternion that is within the given tolerance
%of the center quaternion. Average the quaternions.

%Window size should be small enough that there is no chance multiple
%symmetries of each orientation can simultaneously exist inside the window.

%All orientations and symmetry operators input as quaternion column
%vectors, with convention of the 4th term being the real term. The
%misorientation window size maxMiso is input in radians.

function [rotated_quats, avg_q] = q_average_orientations_in_window(quats,centerQ,maxMiso,q_symops)

N = length(quats(1,:));
nsym = length(q_symops(1,:));

%Generate all positive and negative quaternion symmetries of each input
%quaternion
rotated_quats = zeros(4,N);
for i=1:N
    
    %Get current orientation quaternion
    curr_q = quats(:,i);
    
    %Generate all symmetries of current orientations
    all_syms = zeros(4,2*nsym);
    for j=1:nsym
        curr_sym = quatLmult(q_symops(:,j),curr_q);
        
        all_syms(:,j) = curr_sym;
        all_syms(:,j+nsym) = -1*curr_sym;

    end
    
    %Find one symmetry inside of window. Return error if none or multiple
    %inside of window
    inWindow = q_distfun(centerQ',all_syms')<maxMiso;
    
    if sum(inWindow)~=1 
        error('Input orientation fails window check');
    end
    
    rotated_quats(:,i) = all_syms(:,inWindow);
    
end

avg_q = sum(rotated_quats,2)/N;
avg_q = avg_q/norm(avg_q);


end