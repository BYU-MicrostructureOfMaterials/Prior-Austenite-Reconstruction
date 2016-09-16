load q_NW_OR_gamma_to_alpha;
load q_NW_OR_alpha_to_gamma;

GtoA = q_NW_OR_gamma_to_alpha;
AtoG = q_NW_OR_alpha_to_gamma;


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
searchQ = Q;
while ~isempty(searchQ)
   
    misos = real(q_min_distfun(searchQ(:,1)',searchQ','cubic'));
    inWindow = misos<(.0001*pi/180);
    overlappingQ = searchQ(:,inWindow);
    
    if sum(inWindow)>1
        orientations = [orientations overlappingQ(:,1)];
    end
    
    searchQ = searchQ(:,~inWindow);
    
end

pole_figure_by_quat(orientations',[],[],'bd',3,1);