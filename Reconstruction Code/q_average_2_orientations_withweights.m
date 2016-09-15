%Find the average orientation for two quaternions that may already be
%averaged quaternions. Input the two orientations and their respective
%weights

%Assumed quats input as column vectors

function [miso_min, rotated_quats, q_avg] = q_average_2_orientations_withweights(Q1, Q2, W1, W2, q_symops)

%find the symmetries of Q1 and Q2 that have the smallest misorientation

Q1_sym = zeros(4,48);
for i=1:24
    Q1_sym(:,i) = quatLmult(q_symops(:,i),Q1);
    Q1_sym(:,i+24) = -1*quatLmult(q_symops(:,i),Q1);
end

Q2_sym = zeros(4,48);
for i=1:24
    Q2_sym(:,i) = quatLmult(q_symops(:,i),Q2);
    Q2_sym(:,i+24) = -1*quatLmult(q_symops(:,i),Q2);
end

misos = zeros(48,48);
for i=1:48
    misos(:,i) = q_distfun(Q2_sym(:,i)',Q1_sym');
end

[C,I] = min(misos);
[miso_min,min_col] = min(C);
min_row = I(min_col);

Q1_rotated = Q1_sym(:,min_row);
Q2_rotated = Q2_sym(:,min_col);
rotated_quats = [Q1_rotated Q2_rotated];

Qsum = (W1*Q1_rotated) + (W2*Q2_rotated);

avg = Qsum/(W1+W2);
q_avg = avg/norm(avg);

end