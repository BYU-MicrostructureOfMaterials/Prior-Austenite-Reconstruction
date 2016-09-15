function superimposedIPFimage = superimposedIPF(IPFimage, matrix)

if max(max(matrix))>1
    matrix = matrix/max(max(matrix));
end

superimposedIPFimage = IPFimage;

superimposedIPFimage(:,:,1) = superimposedIPFimage(:,:,1).*matrix;
superimposedIPFimage(:,:,2) = superimposedIPFimage(:,:,2).*matrix;
superimposedIPFimage(:,:,3) = superimposedIPFimage(:,:,3).*matrix;
        

end