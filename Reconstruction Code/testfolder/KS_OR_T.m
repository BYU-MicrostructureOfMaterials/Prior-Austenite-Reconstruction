% load KS_trans_gmat;
load g_cubic_symops;

%gamma phase basis for OR
u_gamma = [-1 1 1]';
v_gamma = [-1 0 -1]';
w_gamma = cross(u_gamma,v_gamma);

u_gamma = u_gamma/norm(u_gamma);
v_gamma = v_gamma/norm(v_gamma);
w_gamma = w_gamma/norm(w_gamma);

%alpha phase
u_alpha = [0 1 1]';
v_alpha = [-1 1 -1]';
w_alpha = cross(u_alpha,v_alpha);

u_alpha = u_alpha/norm(u_alpha);
v_alpha = v_alpha/norm(v_alpha);
w_alpha = w_alpha/norm(w_alpha);

GtoGamma = [u_gamma,v_gamma,w_gamma];
GtoAlpha = [u_alpha,v_alpha,w_alpha];

KS_T_gtoa = GtoAlpha*(GtoGamma');
KS_T_atog = GtoGamma*(GtoAlpha');

for i=1:24
    KS_gtoa(:,:,i) =KS_T_gtoa*g_cubic_symops(:,:,i);
    KS_atog(:,:,i) =KS_T_atog*g_cubic_symops(:,:,i);
end

pole_figure_by_gmat(KS_atog,[],[],'bd',5);