function Z = fold(z, shape)
%FOLD Convert a 1D row-vector into 2D matrix assuming in row-major order.
%   Exmaple:
%       z = [1 2 3 4 5 6]
%
%       shape = [3 2];
%       Z = [1 4; 
%            2 5; 
%            3 6]
%
%       shape = [2 3];
%       Z = [1 3 5;
%            2 4 6]
%
%   See also: reshape, transpose

    assert(numel(z) == prod(shape), 'Number of elements in z does not match the specified shape.');

    Z = reshape(z, shape);
end