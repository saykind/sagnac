function [X, varargout] = coarse_grain(dx, x1, x2, varargin)
    %Average data in bins of the given size.
    %   Example:
    %   [X, Y1, Y2, Y1_err, Y2_err] = coarse_grain(bin, x1, x2, y1, y2)
    %   X -- array evenly spaced z values with step bin.
    %   Y1, Y2 -- averaged y1 and y2 arrays.
    %   Y1_err -- array of standard errors of averaged values Y1.
    
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
        X(i) = mean(x(idx));
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