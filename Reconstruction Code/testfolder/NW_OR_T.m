load g_cubic_symops;

%gamma phase basis for OR
u_gamma = [1 1 1]';
v_gamma = [1 1 -2]';
w_gamma = cross(u_gamma,v_gamma);

u_gamma = u_gamma/norm(u_gamma);
v_gamma = v_gamma/norm(v_gamma);
w_gamma = w_gamma/norm(w_gamma);

%alpha phase
u_alpha = [1 1 0]';
v_alpha = [1 -1 0]';
w_alpha = cross(u_alpha,v_alpha);

u_alpha = u_alpha/norm(u_alpha);
v_alpha = v_alpha/norm(v_alpha);
w_alpha = w_alpha/norm(w_alpha);

GtoGamma = [u_gamma,v_gamma,w_gamma];
GtoAlpha = [u_alpha,v_alpha,w_alpha];

NW_T_gtoa = GtoAlpha*(GtoGamma');
NW_T_atog = GtoGamma*(GtoAlpha');


for i=1:24
    NW_gtoa(:,:,i) =NW_T_gtoa*g_cubic_symops(:,:,i);
    NW_atog(:,:,i) =NW_T_atog*g_cubic_symops(:,:,i);
end

%Separate symmetric gtoa matrices to reduce the list to unique variants
unique_count = 0;
for i=1:24
    A = NW_gtoa(:,:,i);
    symmetries_count = 0;
    if i<24
        for j=i+1:24
            B = NW_gtoa(:,:,j);
            if is_gmat_symmetric(A,B)
                symmetries_count = symmetries_count + 1;
            end
        end
        if symmetries_count ==0
            unique_count = unique_count + 1;
            unique_NW_gtoa(:,:,unique_count) = A;
        end
    elseif i ==24
        unique_count = unique_count + 1;
        unique_NW_gtoa(:,:,unique_count) = A;
    end
end

%Separate symmetric atog matrices to reduce the list to unique variants
unique_count = 0;
for i=1:24
    A = NW_atog(:,:,i);
    symmetries_count = 0;
    if i<24
        for j=i+1:24
            B = NW_atog(:,:,j);
            if is_gmat_symmetric(A,B)
                symmetries_count = symmetries_count + 1;
            end
        end
        if symmetries_count ==0
            unique_count = unique_count + 1;
            unique_NW_atog(:,:,unique_count) = A;
        end
    elseif i ==24
        unique_count = unique_count + 1;
        unique_NW_atog(:,:,unique_count) = A;
    end
end

% unique_NW = bruteforce_rot_gmat_2fundzone(unique_NW,symops);
% pole_figure_by_gmat(unique_NW,[],[],'bd',5);