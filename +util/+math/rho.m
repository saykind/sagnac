function r = rho(x, shift)
%Calculate the autocorrelation coefficient for a time series x at a given shift.
% See https://saykind.atlassian.net/l/cp/FkVQYp2s
% See https://en.wikipedia.org/wiki/Autoregressive_model
% See https://esajournals.onlinelibrary.wiley.com/doi/epdf/10.2307/1941218

    if nargin < 2, shift = 1; end
    x = x - mean(x);
    x1 = x(1:end-shift);
    x2 = x(1+shift:end);
    r = dot(x1,x2)/dot(x1,x1);