%Quaternions must be input as column vectors with the real term last
%RF vectors output as column vectors

%Not robust in the case where an RF vector lies in the planar boundary
%between octants

function [fund_R] = quat2fundRF(q,q_symops_mat)

n = length(q(1,:));
fund_R = zeros(3,n);

cube_bound = tan(pi/8);
oct_bound = tan(pi/6);
bound_tol = 1e-12;

for i=1:n
    curr_q = q(:,i);
    qsyms = zeros(4,24);
    
    %generate each quaternion symmetry
    for j=1:24
        qsyms(:,j) = q_symops_mat(:,:,j)*curr_q;
    end
    
    %check each symmetry to see if RF version is within fundamental zone
    FZ_check = zeros(1,24);
    mult_fund_R = zeros(3,24);
    for j=1:24
        curr_sym = qsyms(:,j);
        q_axis = [curr_sym(1); curr_sym(2); curr_sym(3)];
        q_axis = q_axis/norm(q_axis);
        curr_angle = 2*acos(curr_sym(4));
        
        if abs(curr_angle)<bound_tol
            curr_RF = [0; 0; 0];
        else
            curr_RF = tan(curr_angle/2)*q_axis;
        end
        
%         plot_RF_FZc(curr_RF,[],'bd',3,1);
        
        curr_axis = curr_RF/norm(curr_RF);
        
        X = curr_RF(1); %if X-cube_bound<bound_tol && X-cube_bound>0, X=cube_bound; end
        Y = curr_RF(2); %if Y-cube_bound<bound_tol && Y-cube_bound>0, Y=cube_bound; end
        Z = curr_RF(3); %if Z-cube_bound<bound_tol && Z-cube_bound>0, Z=cube_bound; end
        
        if X>=0
            %bound by +X plane
            if Y>=0
                %bound by +Y plane
                if Z>=0
                    %bound by +Z
                    %bound by +++ octahedral plane
                    comp_dir = (1/sqrt(3))*[1 1 1];
                    component = dot(curr_RF,comp_dir);
                    if X<=cube_bound+bound_tol && Y<=cube_bound+bound_tol && Z<=cube_bound+bound_tol && component<=oct_bound+bound_tol
                        FZ_check(j) = 1;
                        fund_R(:,i) = curr_RF;
                        mult_fund_R(:,j) = curr_RF;
                    end
                elseif Z<0
                    %bound by -Z
                    %bound by ++- octahedral plane
                    comp_dir = (1/sqrt(3))*[1 1 -1];
                    component = dot(curr_RF,comp_dir);
                    if X<=cube_bound+bound_tol && Y<=cube_bound+bound_tol && Z>=-cube_bound+bound_tol && component<=oct_bound+bound_tol
                        FZ_check(j) = 1;
                        fund_R(:,i) = curr_RF;
                        mult_fund_R(:,j) = curr_RF;
                    end
                end
            elseif Y<0
                %bound by -Y
                if Z>=0
                    %bound by +Z
                    %bound by +-+ octahedral plane
                    comp_dir = (1/sqrt(3))*[1 -1 1];
                    component = dot(curr_RF,comp_dir);
                    if X<=cube_bound+bound_tol && Y>=-cube_bound+bound_tol && Z<=cube_bound+bound_tol && component<=oct_bound+bound_tol
                        FZ_check(j) = 1;
                        fund_R(:,i) = curr_RF;
                        mult_fund_R(:,j) = curr_RF;
                    end
                elseif Z<0
                    %bound by -Z
                    %bound by +-- octahedral plane
                    comp_dir = (1/sqrt(3))*[1 -1 -1];
                    component = dot(curr_RF,comp_dir);
                    if X<=cube_bound+bound_tol && Y>=-cube_bound+bound_tol && Z>=-cube_bound+bound_tol && component<=oct_bound+bound_tol
                        FZ_check(j) = 1;
                        fund_R(:,i) = curr_RF;
                        mult_fund_R(:,j) = curr_RF;
                    end
                end
            end
        elseif X<0
            %bound by -X plane
            if Y>=0
                %bound by +Y plane
                if Z>=0
                    %bound by +Z plane
                    %bound by -++ octahedral plane
                    comp_dir = (1/sqrt(3))*[-1 1 1];
                    component = dot(curr_RF,comp_dir);
                    if X>=-cube_bound+bound_tol && Y<=cube_bound+bound_tol && Z<=cube_bound+bound_tol && component<=oct_bound+bound_tol
                        FZ_check(j) = 1;
                        fund_R(:,i) = curr_RF;
                        mult_fund_R(:,j) = curr_RF;
                    end
                elseif Z<0
                    %bound by -Z plane
                    %bound by -+- octahedral plane
                    comp_dir = (1/sqrt(3))*[-1 1 -1];
                    component = dot(curr_RF,comp_dir);
                    if X>=-cube_bound+bound_tol && Y<=cube_bound+bound_tol && Z>=-cube_bound+bound_tol && component<=oct_bound+bound_tol
                        FZ_check(j) = 1;
                        fund_R(:,i) = curr_RF;
                        mult_fund_R(:,j) = curr_RF;
                    end
                end
            elseif Y<0
                %bound by -Y plane
                if Z>=0
                    %bound by +Z plane
                    %bound by --+ octahedral plane
                    comp_dir = (1/sqrt(3))*[-1 -1 1];
                    component = dot(curr_RF,comp_dir);
                    if X>=-cube_bound+bound_tol && Y>=-cube_bound+bound_tol && Z<=cube_bound+bound_tol && component<=oct_bound+bound_tol
                        FZ_check(j) = 1;
                        fund_R(:,i) = curr_RF;
                        mult_fund_R(:,j) = curr_RF;
                    end
                elseif Z<0
                    %bound by -Z plane
                    %bound by --- octahedral plane
                    comp_dir = (1/sqrt(3))*[-1 -1 -1];
                    component = dot(curr_RF,comp_dir);
                    if X>=-cube_bound+bound_tol && Y>=-cube_bound+bound_tol && Z>=-cube_bound+bound_tol && component<=oct_bound+bound_tol
                        FZ_check(j) = 1;
                        fund_R(:,i) = curr_RF;
                        mult_fund_R(:,j) = curr_RF;
                    end
                end
            end
        end  
    end
    
    if sum(FZ_check)>1
        warning('More than one symmetry found in FZ');
    end
    
    if sum(FZ_check)==0
        warning('No symmetry found in FZ');
    end
    
end

end