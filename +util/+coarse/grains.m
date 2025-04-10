function [X, Y, Y2] = grains(dx, x, y)
%Function averages data over an x-grid with step dx.
%
%   Inputs:
%       dx - Averaging grid step size (scalar).
%       x - cell array of arrays of values that the data should be averaged over.
%       y - cell array of arrays of data that should be averaged. The number of these arrays should match the number of output arrays.
%
%   Outputs:
%       X - 1d array of x values for the output arrays.
%       Y - cell array of arrays of averaged data.
%       Y2 - cell array of arrays of standard errors of the averaged values.
%
%   Example:
%       x1 = [ 1,  2, 2.3, 2.6,  3,  4,  5]
%       y1 = [10, 20,  23,  26, 30, 40, 50]
%       x2 = [0.5, 1.5, 2.5]
%       y2 = [ 10,  10,  10]
%       [X, Y] = grains(1, {x1, x2}, {y1, y2});
%
%       in this example x{1} = [1, 2, 3, 4, 5], x{2} = [0.5, 1.5, 2.5]
%       grid is created with step 1, so the grid is 
%           dX = [0,   1,   2,   3,   4,   5,   6]
%       centers of the grid points are 
%           X    = [0.5, 1.5, 2.5, 3.5, 4.5, 5.5]
%           Y{1} = [NaN,  10,  23,  30,  40,  50]
%           Y{2} = [10, 10, 10, NaN, NaN, NaN]



arguments
    dx (1,1) double
    x cell
    y cell
end

    assert(numel(x) == numel(y), "Number of x arrays must match number of output arrays.");
    num_arrays = numel(x);

    % Find minimum and maximum values of x arrays 
    x_min = min(cellfun(@min, x));
    x_max = max(cellfun(@max, x));
    dX = util.coarse.grid(dx, x_min, x_max);
    X = util.coarse.grid(-dx, x_min, x_max);

    Y = cell(1, numel(y));
    Y2 = cell(1, numel(y));

    for i = 1:num_arrays
        Y{i} = zeros(size(X));
        Y2{i} = zeros(size(X));
        for j = 1:numel(X)
            idx = find(x{i} >= dX(j) & x{i} < dX(j+1));
            if isempty(idx)
                Y{i}(j) = NaN;
                Y2{i}(j) = NaN;
            else
                Y{i}(j) = mean(y{i}(idx));
                Y2{i}(j) = std(y{i}(idx))/sqrt(numel(idx));
            end
        end
    end


