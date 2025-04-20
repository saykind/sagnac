function Z = fold(z, shape)
%FOLD Convert a 1D row-vector into 2D matrix assuming in row-major snake order.
%   Exmaple:
%       z = [1 2 3 4 5 6]
%
%       shape = [3 2];
%       Z = [1 2; 
%            3 4; 
%            5 6]
%
%       shape = [2 3];
%       Z = [1 2 3;
%            4 5 6]
%
%   See also: reshape, transpose

    assert(numel(z) == prod(shape), 'Number of elements in z does not match the specified shape.');

    Z = reshape(z', shape(2), shape(1));    % Reshape z into a 2D matrix
    Z = Z';                                 % Transpose to get the correct orientation
    Z(2:2:end, :) = Z(2:2:end, end:-1:1);   % Reverse the order inside each even row

end