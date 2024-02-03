function X = grid(dx, x1, xmax)
    %GRID Creates a regular grid based on the given step size and input array.
    %
    %  Inputs:
    %    dx:    Scalar that defines the step size for the grid. 
    %           If dx = 0, the output X will be the same as the input x1.
    %           If dx < 0, the grid points are aligned with the steps.
    %    x1:    Could be a scalar or an array.
    %           When scalar it is center of the first grid point (when dx>0) 
    %               or the minimum value of the grid (when dx<0).
    %           When array, xmax is unused and min(x1) and max(x1) are used as the limits.
    %    xmax:  is the center of the last grid point (when dx>0)
    %           or the maximum value of the grid (when dx<0).
    %
    %  Outputs:
    %    X:     Regular grid array. If dx > 0, the grid points are centered between the steps. 
    %
    %  Examples: 
    %   X = grid(0.5, 1, 3) --> X = [0.75, 1.25, 1.75, 2.25, 2.75, 3.25]
    %   X = grid(1, 0.5, 1.5) --> X = [0, 1, 2]
    %   X = grid(-1, 0.5, 1.5) --> X = [0.5, 1.5]
    %
    % See also: linspace
    
    if dx == 0
        X = x1;
        return
    end

    if nargin < 3
        xmax = max(x1);
        xmin = min(x1);
    else
        xmin = min(x1,xmax);
        xmax = max(x1,xmax);
    end

    step = abs(dx);

    if dx > 0
        xmin = xmin - step/2;
    end

    n = floor((xmax-xmin)/step);
    if dx > 0
        n = n + 1;
    end

    xmax = xmin + n*step;

    X = linspace(xmin,xmax,n+1);
end
