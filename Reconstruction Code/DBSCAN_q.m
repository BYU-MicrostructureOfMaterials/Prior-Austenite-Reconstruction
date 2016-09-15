%This function runs the "Density-Based Spatial Clustering of Applications
%with Noise" algorithm, returning an array with assigned cluster numbers for
%each element of "data"

function clusters = DBSCAN_q(data, eps, minpts, q_symops)

toVisit = ones(1,length(data(1,:)));  %1 for unvisited, 0 for visited <----------depends on format of "data"
clusters = zeros(1,length(data(1,:))); %0 for noise point, integer as cluster number <----------depends on format of "data"

curr_cluster = 0;

ind = find(toVisit,1,'first');
while ~isempty(ind)
    
    toVisit(ind) = 0;
    P = data(:,ind); %<----------depends on format of "data"
    neighborhood = regionCheck_q(data, P,eps, q_symops);
    if length(neighborhood) >= minpts
        curr_cluster = curr_cluster + 1;
        [toVisit, clusters] = expandCluster_q(data, ind, neighborhood, curr_cluster, toVisit, clusters, eps, minpts, q_symops);
    end
    ind = find(toVisit,1,'first');
    
    visited = find(toVisit==0);
    disp(length(visited));
    
end

end