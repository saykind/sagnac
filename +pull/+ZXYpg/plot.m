function graphics = plot(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.cutoff (1,1) logical = true;
    options.plot_curr (1,1) logical = true;
    options.correct_offset (1,1) logical = false;
end

    axisA = graphics.axes(1);
    axisB = graphics.axes(2);
    cla(axisA);
    cla(axisB);

    p0  = 1e3*logdata.lockin.auxin0(:,1);            % DC Power, uW
    p0  = p0 + 7;
    ixxX = 1e12*logdata.lockinA.X;                     % Photogalv curr, nA
    ixxY = 1e12*logdata.lockinA.Y;                     % Photogalv curr, nA
    % ixx  = sqrt(ixxX.^2 + ixxY.^2);                    % Photogalv curr, nA
    ixx = ixxX;

    n = numel(p0);
    k = logdata.sweep.rate-logdata.sweep.pause;
    k = k(1);
    m = fix(n/k);

    Ixx = mean(reshape(ixx, [k, m]),1);
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

    I = zeros(1, n0);
    I(1:n_curr) = Ixx;
    if n_curr ~= n0, I(n_curr:end) = I(1); end
    Ixx = util.mesh.column.fold(I, shape);

    axis(axisA, 'tight');
    axis(axisB, 'tight');
    surf(axisA, X, Y, P0, 'EdgeAlpha', .2);
    
    if options.plot_curr
        surf(axisB, X, Y, Ixx, 'EdgeAlpha', .2);
    else
        util.donothing();
    end
    
end