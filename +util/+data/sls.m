function s = sls(v0, v2)
    % Find second harmonic lcokin sensitivity s,
    % based at the fact that (s*v2/v) = .33
    % Possible options for s:
    % 1. .250
    % 2. .100
    % 3. .025
    % 4. .010

    r = mean(.33 * v0 ./ v2);
    s_options = [.250, .100, .025, .010];
    [minValue,closestIndex] = min(abs(r-s_options));
    s = s_options(closestIndex);
end

