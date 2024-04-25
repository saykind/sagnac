function graphics = xy(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.cutoff (1,1) logical = true;
end

    axisA = graphics.axes(1);
    axisB = graphics.axes(2);
    cla(axisA);
    cla(axisB);

    resp_dc = 4.7;   %   V/mW
    resp_ac = 5.15;   %   V/mW
    splitter = .673;

    p0  = 1e3*logdata.voltmeter.v1;                 % DC Power, uW
    V1X = 1e3*logdata.lockin.X;                     % 1st harm Power X, mV
    V1Y = 1e3*logdata.lockin.Y;                     % 1st harm Power Y, mV
    V2X  = 1e3*logdata.lockin.AUX1;                 % 2nd harm Power R, mV
    V2Y  = 1e3*logdata.lockin.AUX2;                 % 2nd harm Power R, mV
    V2   = sqrt(V2X.^2+V2Y.^2);
    try
        sls = util.data.sls(p0, V2);
        %disp(sls);
    catch
        disp("Wasn't able to find correct lockin sensitivity;")
    end
    V2 = sls*V2;

    kerr = util.math.kerr(V1X, V2);

    n = numel(kerr);
    k = logdata.sweep.rate-logdata.sweep.pause;
    k = k(1);                                       %FIXME
    m = fix(n/k);
    KERR = mean(reshape(kerr, [k, m]),1);
    P0 = mean(reshape(p0, [k, m]),1);

    shape = logdata.sweep.shape;
    x = 1e3*logdata.sweep.range(1,:);
    y = 1e3*logdata.sweep.range(2,:);
    if isfield(logdata.sweep, 'origin')
        x = x - 1e3*logdata.sweep.origin(1);
        y = y - 1e3*logdata.sweep.origin(2);
    end

    X = util.mesh.combine(x, shape);
    Y = util.mesh.combine(y, shape);
    n0 = length(logdata.sweep.range);
    n_curr = length(P0);

    p0 = zeros(1, n0);
    p0(1:n_curr) = P0;
    if n_curr ~= n0, p0(n_curr:end) = p0(1); end
    P0 = util.mesh.combine(p0, shape);

    kerr = zeros(1, n0);
    kerr(1:n_curr) = KERR;
    if n_curr ~= n0, kerr(n_curr:end) = kerr(1); end
    KERR = util.mesh.combine(kerr, shape);

    %P0 = log(P0);
    % Mask low power points
    P0_cutoff = 200;
    P0_maxlim = inf;
    n_cutoff = 5*fix(n0/4);
    if options.cutoff && n_curr > n_cutoff
        low_power_idx = P0 < P0_cutoff;
        KERR_good = KERR(~low_power_idx);
        kerr_max = max(KERR(~low_power_idx));
        kerr_min = min(KERR(~low_power_idx));
        P0_min = min(P0(~low_power_idx));
        P0_max = max(P0(~low_power_idx));
        kerr_bad = mean([kerr_max kerr_min]) + kerr_max-kerr_min;
        KERR(low_power_idx) = kerr_bad;
    end

    axis(axisA, 'tight');
    axis(axisB, 'tight');
    surf(axisA, X, Y, P0, 'EdgeAlpha', .2);
    surf(axisB, X, Y, KERR, 'EdgeAlpha', .2);

    if n_curr > n_cutoff
        low_power_idx = P0 < P0_cutoff;
        if any(low_power_idx, 'all')
            zlim(axisA, [P0_cutoff inf]);
            caxis(axisA, [P0_cutoff P0_maxlim]); %Renamed to clim in R2022a
            zlim(axisB, [kerr_min kerr_max]);
            caxis(axisB, [kerr_min kerr_max]); %Renamed to clim in R2022a
        end
        if n_curr == n0
            kerr_std = std(KERR(~low_power_idx));
            kerr_mean = mean(KERR(~low_power_idx));
            fprintf("kerr_avg = %.1f urad.\n", kerr_mean);
            fprintf("kerr_std = %.1f urad.\n", kerr_std);
        end
    else
        caxis(axisA, [-inf inf]);  %Renamed to clim in R2022a
        caxis(axisB, [-inf inf]); %Renamed to clim in R2022a
    end
    
end