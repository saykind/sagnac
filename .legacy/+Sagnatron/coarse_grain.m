function [X, varargout] = coarse_grain(dx, x, varargin)
    %Average data in bins of the given size.
    %   Example:
    %   [X, Y, Z, Y2] = coarse_grain(bin, x, y, z)
    %   X -- array of averaged x values with step bin.
    %   Y, Z -- averaged y and z arrays.
    %   Y2 -- array of standard errors of averaged values.
    
    xmin = dx*round(min(x)/dx);
    xmax = dx*round(max(x)/dx);
    num_in = nargin-2;
    num_out = nargout-1;
    d = dx/2;
    n = round((xmax-xmin)/d)-1;

    X = zeros(1,n);
    Y = cell(1, num_in);
    Y2 = cell(1, num_out-num_in);
    for j = 1:num_in
        Y{j} = zeros(1,n);
    end
    for j = 1:(num_out-num_in)
        Y2{j} = zeros(1,n);
    end
    
    i = 1;
    for z = xmin+d : d : xmax-d
        idx = find(x>=z-d & x<z+d);
        %X(i) = mean(x(idx));
        X(i) = z;
        for j = 1:num_in
            y = varargin{j};
            Y{j}(i) = mean(y(idx));
            if num_out > num_in+j-1
                Y2{j}(i) = sqrt(mean(y(idx).^2) - Y{j}(i)^2)/sqrt(length(idx))*2.5;   
                %Factor of 2.5 is a fudge to handle correlation between data points 
                %   (1s log time, 1s TC, 24 dB/oct)
            end
        end
        i = i + 1;
    end
    
    for j = 1:num_in
        varargout{j} = Y{j};
    end
    for j = 1:(num_out-num_in)
        varargout{num_in+j} = Y2{j};
    end
end