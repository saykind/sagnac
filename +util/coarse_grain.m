function [X, varargout] = coarse_grain(x0, x, varargin)
    %Average data in bins of the given size.
    %   Example:
    %   [X, Y, Z, Y2] = coarse_grain(x0, x, y, z)
    %       x0  -- averaging grid or scalar step size
    %       X   -- array of averaged x values over window dx.
    %       Y,Z -- averaged y and z arrays.
    %       Y2  -- array of standard errors of averaged values.
    
    if isscalar(x0)
        x0 = util.coarse_grid(x0, x);
    end
    
    num_in = nargin-2;
    num_out = nargout-1;
    Y = cell(1, num_in);
    Y2 = cell(1, num_out-num_in);
    
    n = numel(x0)-1;
    X = zeros(1,n);
    for j = 1:num_in, Y{j} = zeros(1,n); end
    for j = 1:(num_out-num_in), Y2{j} = zeros(1,n); end
    
    i = 1;
    while i < n+1
        idx = find(x>=x0(i) & x<x0(i+1));
        if isempty(idx)
            x0(i) = [];
            X(i) = [];
            for j = 1:num_in
                Y{j}(i) = [];
                if num_out > num_in+j-1
                    Y2{j}(i) = [];
                end
            end
            n = n - 1;
        else
            X(i) = mean(x(idx));
            for j = 1:num_in
                y = varargin{j};
                Y{j}(i) = mean(y(idx));
                if num_out > num_in+j-1
                    var_est = (mean(y(idx).^2) - Y{j}(i)^2)/length(idx);
                    Y2{j}(i) = sqrt(var_est);
                end
            end
            i = i + 1;
        end
    end
    
    for j = 1:num_in, varargout{j} = Y{j}; end
    for j = 1:(num_out-num_in), varargout{num_in+j} = Y2{j}; end
end