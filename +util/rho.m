function r = rho(x, shift)
    if nargin < 2, shift = 1; end
    x = x - mean(x);
    x1 = x(1:end-shift);
    x2 = x(1+shift:end);
    r = dot(x1,x2)/dot(x1,x1);