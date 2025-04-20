function z = flatten(Z)
%FLATTEN Convert a 2D matrix to a 1D row-vector in column-major snake order.
%   Since y coordinate is along the column direction in MATLAB,
%   this order corrsponds to sweeping y's fist in forward direction,
%   then incrementing x and sweeping y's in reverse direction, and so on. 
%
%   Exmaple:
%       Z = [1 6; 
%            2 5; 
%            3 4];
%       z = flatten(Z);
%       % z = [1 2 3 4 5 6]
%
%   See also: reshape, transpose

    Z(:, 2:2:end) = Z(end:-1:1, 2:2:end);   % Reverse the order inside each even column
    z = Z(:)';                              % Convert to row vector
end