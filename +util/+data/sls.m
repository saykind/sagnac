function s = sls(v0, v2, f)
    % Find second harmonic lcokin sensitivity s,
    % based at the fact that (s*v2/v) = f
    % f = .33 (for NewFocus1801)
    % f = 4   (for NewFocus1811)
    % Possible options for s:
    % 1. .250
    % 2. .100
    % 3. .025
    % 4. .010

    if nargin < 3
        f = 4;  % NewFocus1811
    end

    r = mean(f * v0 ./ v2);
    s_options = [.250, .100, .025, .010];
    [minValue,closestIndex] = min(abs(r-s_options));
    s = s_options(closestIndex);
end

