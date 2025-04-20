function z = flatten(Z)
%FLATTEN Convert a 2D matrix to a 1D row-vector in row-major order.
%   Since x coordinate is along the row direction in MATLAB,
%   this order corrsponds to sweeping x's fist,
%   then incrementing y and sweeping x's again, and so on. 
%
%   Exmaple:
%       Z = [1 2; 
%            3 4; 
%            5 6];
%       z = flatten(Z);
%       % z = [1 2 3 4 5 6]
%
%   See also: reshape, transpose
    Z = Z';     % Transpose the matrix to get row-major order
    z = Z(:)';  % Convert to row vector
end