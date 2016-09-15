function [toVisit, clusters] = expandCluster_q(data, ind, neighborhood, curr_cluster, toVisit, clusters, eps, minpts, q_symops)

    clusters(ind) = curr_cluster;
    
    neigh_list_ind = 1;
    while neigh_list_ind <= length(neighborhood)
        
        if toVisit(neighborhood(neigh_list_ind))==1
            toVisit(neighborhood(neigh_list_ind)) = 0;
            neigh_P = data(:,neighborhood(neigh_list_ind)); %depends on format of "data"
            next_neighborhood = regionCheck_q(data, neigh_P,eps,q_symops);
            if length(next_neighborhood) >= minpts
                neighborhood = union(neighborhood,next_neighborhood,'stable');
            end
        end
        
        if clusters(neighborhood(neigh_list_ind))==0
            clusters(neighborhood(neigh_list_ind)) = curr_cluster;
        end
        
        neigh_list_ind = neigh_list_ind + 1;
        
        visited = find(toVisit==0);
        disp(length(visited));
        
    end

    
end