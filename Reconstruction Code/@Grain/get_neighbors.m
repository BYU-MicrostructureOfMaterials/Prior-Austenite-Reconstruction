function neighbor_ids = get_neighbors(choice_id, grain_id_mat)

[nrow,ncol] = size(grain_id_mat);
[r,c] = find(grain_id_mat==choice_id);

%Find shifted sets of row and column indices
center = [r c];
L1 = [r c-1];      %Shifted left 1
U1L1 = [r-1 c-1];  %Shifted up 1, left 1
U1 = [r-1 c];      %etc.
U1R1 = [r-1 c+1];
R1 = [r c+1];
D1R1 = [r+1 c+1];
D1 = [r+1 c];
D1L1 = [r+1 c-1];

%combine indices into single array
covered = unique([center; L1; U1L1; U1; U1R1; R1; D1R1; D1; D1L1],'rows');

%find any rows/cols that have gone to zero (chosen grain is on either top or left border)
[zero_rows,zero_cols] = find(covered==0);

%find any rows that have indexes passing the max row or max column (grain on bottom or right border)
[past_rowmax_rows,c] = find(covered(:,1)>nrow);
[past_colmax_rows,c] = find(covered(:,2)>ncol);

rows_to_filter = union(union(past_rowmax_rows,past_colmax_rows),zero_rows);

%filter indexed locations to include only valid options
rows = 1:length(covered(:,1));
filtered_rows = setdiff(rows,rows_to_filter);
covered = covered(filtered_rows,:);

mask = zeros(nrow,ncol);
for i=1:length(covered(:,1))
    mask(covered(i,1),covered(i,2)) = 1;
end

neighbor_ids = unique(int32(mask).*grain_id_mat);
neighbor_ids = setdiff(neighbor_ids, [0 choice_id]);
neighbor_ids = neighbor_ids';

end