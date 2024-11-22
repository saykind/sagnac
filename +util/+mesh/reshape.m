function varargout = reshape(shape, varargin)
%Change the shape of an array from (1,n*m) to (n, m) or vice versa.
    [n, m] = util.unpack(shape);
    n0 = n*m;

    for var = 1:length(varargin)
        z = varargin{var};
        
        [nz, mz] = size(z);

        if nz == 1
            if mz < n0
                z = [z, z(end)*ones(1,n0-mz)];
            end
            Z = util.mesh.combine(z, [n,m]);
        elseif nz == n && mz == m
            Z = util.mesh.flatten(z);
        end

        varargout{var} = Z;
    end