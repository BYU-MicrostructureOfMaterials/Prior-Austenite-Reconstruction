function is_symmetric = is_gmat_symmetric(A,B)

is_symmetric = false;
tol = 1e-10;
mat = A*B';

if sum(sum(abs(mat)))<=(3+tol)
    is_symmetric = true;
end


end