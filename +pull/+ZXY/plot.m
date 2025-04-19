function graphics = plot(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.cutoff (1,1) logical = true;
    options.plot_kerr (1,1) logical = true;
    options.correct_offset (1,1) logical = false;
end

    axisA = graphics.axes(1);
    axisB = graphics.axes(2);
    cla(axisA);
    cla(axisB);

    p0  = 1e3*logdata.lockin.auxin0(:,1);                 % DC Power, uW
    p0  = p0 + 6;
    [x1, y1, x2, y2, r1, r2, kerr] = ...
        util.logdata.lockin(logdata.lockin);

    n = numel(kerr);
    k = logdata.sweep.rate-logdata.sweep.pause;
    k = k(1);
    m = fix(n/k);
    X1 = mean(reshape(x1, [k, m]),1);
    KERR = mean(reshape(kerr, [k, m]),1);
    P0 = mean(reshape(p0, [k, m]),1);

    shape = logdata.sweep.shape;
    x = 1e3*logdata.sweep.range(1,:);
    y = 1e3*logdata.sweep.range(2,:);
    if isfield(logdata.sweep, 'origin')
        x = x - 1e3*logdata.sweep.origin(1);
        y = y - 1e3*logdata.sweep.origin(2);
    end

    X = reshape(x', shape);
    Y = reshape(y', shape);
    n0 = length(logdata.sweep.range);
    n_curr = length(P0);

    p0 = zeros(1, n0);
    p0(1:n_curr) = P0;
    if n_curr ~= n0, p0(n_curr:end) = p0(1); end
    P0 = reshape(p0', shape);

    kerr = zeros(1, n0);
    kerr(1:n_curr) = KERR;
    if n_curr ~= n0, kerr(n_curr:end) = kerr(1); end
    KERR = reshape(kerr', shape);

    x1 = zeros(1, n0);
    x1(1:n_curr) = X1;
    if n_curr ~= n0, x1(n_curr:end) = x1(1); end
    X1 = reshape(x1', shape);

    % Substract Kerr vs 1/P0 dependence
    if options.correct_offset
        slope = -200; % urad/mV
        KERR_inf = 0; % urad
        KERR = KERR - (slope./P0 + KERR_inf);
    end

    axis(axisA, 'tight');
    axis(axisB, 'tight');
    surf(axisA, X, Y, P0, 'EdgeAlpha', .2);
    
    if options.plot_kerr
        surf(axisB, X, Y, KERR, 'EdgeAlpha', .2);
    else
        surf(axisB, X, Y, X1, 'EdgeAlpha', .2);
    end
    
end