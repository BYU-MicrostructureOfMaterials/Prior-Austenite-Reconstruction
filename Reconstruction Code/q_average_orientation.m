%Find the average orientation for a collection of quaternion data.

%This method may be inaccurate in the case of very large amount of spread in
%data (enough for clouds to overlap in orientation space).

%This method generates clouds of orientations in quaternion space 
%(taking both negative and positive quaternions into account). Each 
%cloud/cluster is found using an agglomerative hierarchical clustering
%algorithm. The cloud providing the minimum sum of mutual misorientations 
%is chosen as the set of quaternions to average

%Assumed quats input as column vectors

function [cluster_miso_sum, rotated_quats, q_avg] = q_average_orientation(quats, q_symops)

N = length(quats(1,:));
nsym = length(q_symops(1,:));
all_syms = zeros(4,N*2*nsym);
quat_id = zeros(N*2*nsym);

%Generate all positive and negative quaternion symmetries of each input
%quaternion
count = 1;
for i=1:N
    curr_q = quats(:,i);
    for j=1:nsym
        curr_sym = quatLmult(q_symops(:,j),curr_q);
        
        all_syms(:,count) = curr_sym;
        quat_id(count) = i;
        count = count + 1;
        
        all_syms(:,count) = -1*curr_sym;
        quat_id(count) = i;
        count = count + 1;
    end
end

%Find all clusters of orientations in quaternion space
X = all_syms'; %Quaternions need to be row vectors for 'linkage' function
Z = linkage(X,'single','q_distfun');
T = cluster(Z,'maxclust',2*nsym);

if length(unique(T))~=(2*nsym)
    error('Number of clusters found in quaternion space not correct');
end

% disp('Clustering finished');

%Calculate the mutual misorientation sum of each element in each cluster
cluster_miso_sums = zeros(1,2*nsym);
for i=1:2*nsym
    inds = find(T==i);
    clust = all_syms(:,inds);
    
    clust_sum = 0;
    for j = 1:length(inds)
        misos = q_distfun(clust(:,j)',clust');
        clust_sum = clust_sum + sum(misos);
    end
    
    cluster_miso_sums(i) = clust_sum;
    
end

%Choose the cluster with the smallest sum of mutual misorientations to
%average
[cluster_miso_sum, best_clust_ind] = min(cluster_miso_sums);   
inds = find(T==best_clust_ind);
rotated_quats = all_syms(:,inds);

%Compute average orientation
avg = sum(rotated_quats,2)/length(inds);
q_avg = avg/norm(avg);

end