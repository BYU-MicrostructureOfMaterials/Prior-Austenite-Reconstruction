function neighborhood = regionCheck_q(data, P, eps, q_symops)

nsym = length(q_symops(1,:));

P_sym = zeros(2*nsym,4);
for i=1:nsym
    P_sym(:,i) = quatLmult(q_symops(:,i),P);
    P_sym(:,i+nsym) = -1*P_sym(i,:);
end

cos_dist = P_sym'*data;
max_cosines = max(cos_dist,[],1);
angular_distances = real(2*acos(max_cosines)); %rounding errors result in cosines greater than one, resulting in imaginary output from acos. Fix rounding errors (renormalize quaternions)
neighborhood = find(angular_distances < eps);


end