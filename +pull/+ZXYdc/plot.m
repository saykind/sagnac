function graphics = plot(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.cutoff (1,1) logical = true;
end

    ax = graphics.axes;
    cla(ax);

    p0  = 1e3*logdata.lockin.auxin0(:,1);                 % DC Power, uW
    p0  = p0 + 7;

    n = numel(p0);
    k = logdata.sweep.rate-logdata.sweep.pause;
    k = k(1);
    m = fix(n/k);
    P0 = mean(reshape(p0, [k, m]),1);

    shape = logdata.sweep.shape;
    x = 1e3*logdata.sweep.range(1,:);
    y = 1e3*logdata.sweep.range(2,:);
    if isfield(logdata.sweep, 'origin')
        x = x - 1e3*logdata.sweep.origin(1);
        y = y - 1e3*logdata.sweep.origin(2);
    end

    X = util.mesh.column.fold(x, shape);
    Y = util.mesh.column.fold(y, shape);
    n0 = length(logdata.sweep.range);
    n_curr = length(P0);

    p0 = zeros(1, n0);
    p0(1:n_curr) = P0;
    if n_curr ~= n0, p0(n_curr:end) = p0(1); end
    P0 = util.mesh.column.fold(p0, shape);

    axis(ax, 'tight');
    surf(ax, X, Y, P0, 'EdgeAlpha', .2);

end