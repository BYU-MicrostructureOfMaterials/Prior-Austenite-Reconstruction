load q_KS_OR_gamma_to_alpha;
load q_KS_OR_alpha_to_gamma;
load quat_cubic_symops;

GtoA = q_KS_OR_gamma_to_alpha;
AtoG = q_KS_OR_alpha_to_gamma;

% startQ = currClust.clusterOCenter.quat;

count = 1;
for i=1:length(GtoA(1,:))
    
    for j = 1:length(AtoG(1,:))
    
        Q(:,count) = quatLmult(AtoG(:,j),GtoA(:,i));
        
%         hold = quatLmult(GtoA(:,i),startQ);
%         rotatedQ(:,count) = quatLmult(AtoG(:,j),hold);
        
        count = count + 1;
        
    end
    
end

%%

orientations = [];
var = 4;
% hold = Q(:,[1:24 (24*(var-1))+1:var*24]);
searchQ = Q;%hold;
while ~isempty(searchQ)
   
    misos = real(q_min_distfun(searchQ(:,1)',searchQ','cubic'));
    inWindow = misos<(.0001*pi/180);
    overlappingQ = searchQ(:,inWindow);
    
    if sum(inWindow)== 6
        orientations = [orientations overlappingQ(:,1)];
    end
    
    searchQ = searchQ(:,~inWindow);
    
end

pole_figure_by_quat(orientations','rd',3,1);
title('<001>');