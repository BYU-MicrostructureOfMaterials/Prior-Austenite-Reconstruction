function [IDs] = point_select_IPF_data(I, id_mat)

%look into impixelregion
[c,r,P] = impixel(I);

mattype = iscell(id_mat);


if mattype
    IDs = cell(1,length(c));
else
    IDs = zeros(1,length(c));
end

for i=1:length(c)
    column = c(i);
    row = r(i);
    
    if mattype
        IDs{i} = id_mat{row,column};
    else
        IDs(i) = id_mat(row,column);
    end
        
end

if mattype
    IDs = [IDs{:}];
end

end