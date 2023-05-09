function X = coarse_grid(dx, x)
    %Given array x and step dx make a regular grid X.
    
    if dx == 0
        X = x;
        return
    end
    step = abs(dx);
    xmin = step*round(min(x)/step);
    xmax = step*round(max(x)/step);
    n = round((xmax-xmin)/step)+1;
    if dx > 0
        X = linspace(xmin,xmax+step,n+1)-step/2;
    else
        X = linspace(xmin,xmax,n);
    end
end