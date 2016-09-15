function [BW,IDs] = poly_select_IPF_data(I, id_mat)

BW = roipoly(I);

IDs = id_mat(BW);

if iscell(id_mat)
    IDs = unique([IDs{:}]);
else
    IDs = unique(IDs);
end

end