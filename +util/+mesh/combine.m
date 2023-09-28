function Z = combine(z, shape)
    n = shape(1);
    m = shape(2);
    n0 = n*m;
    if numel(z) ~= n0
        error("[mesh.combine] Incorrect shape.");
    end
    Z = zeros(n,m);
    for i0 = 0:n0-1
        i = fix(i0/m)+1;
        j = mod(i0,m)+1;
        if ~mod(i,2)
            j = m-j+1;
        end
        Z(i,j) = z(i0+1);
    end
end