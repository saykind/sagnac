function z = flatten(Z)
%FLATTEN Convert a 2D matrix to a 1D row-vector in column-major order.
%   Since y coordinate is along the column direction in MATLAB,
%   this order corrsponds to sweeping y's fist,
%   then incrementing x and sweeping y's again, and so on. 
%
%   Exmaple:
%       Z = [1 4; 
%            2 5; 
%            3 6];
%       z = flatten(Z);
%       % z = [1 2 3 4 5 6]
%
%   See also: reshape, transpose
    z = Z(:)';  % Convert to row vector
end