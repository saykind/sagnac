function z = flatten(Z)
%FLATTEN Convert a 2D matrix to a 1D row-vector in row-major snake order.
%   Since x coordinate is along the row direction in MATLAB,
%   this order corrsponds to sweeping x's fist in forward direction
%   then incrementing y and sweeping x's in reverse direction, and so on. 
%
%   Exmaple:
%       Z = [1 2; 
%            4 3; 
%            5 6];
%       z = flatten(Z);
%       % z = [1 2 3 4 5 6]
%
%   See also: reshape, transpose

    Z(2:2:end, :) = Z(2:2:end, end:-1:1);   % Reverse the order inside each even row
    Z = Z';                                 % Transpose the matrix to get row-major order
    z = Z(:)';                              % Convert to row vector
end