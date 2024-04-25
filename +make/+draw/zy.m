function graphics = zy(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.dT (1,1) double = 0;
    options.x1_offset (1,1) double = 0;
    options.coil_const (1,1) double = 25;   % mT/A
end
    options.x1_offset = .5*1e-6;    

    [axisA, axisB, axisC] = util.unpack(graphics.axes);
    for ax = graphics.axes
        yyaxis(ax, 'right'); cla(ax); 
        yyaxis(ax, 'left'); cla(ax);
    end

    I   = 1e3*logdata.magnet.I;         % Magnet curr, mA
    v0  = 1e3*logdata.voltmeter.v1;     % DC Volt, mV
    [x1, y1, x2, y2] = util.logdata.lockin(logdata.lockin);
    if options.x1_offset
        x1 = x1 - options.x1_offset;
    end
    [V1X, V1Y, V2X, V2Y] = deal(1e3*x1, 1e3*y1, 1e3*x2, 1e3*y2);
    V2 = sqrt(V2X.^2+V2Y.^2);

    kerr = util.math.kerr(V1X, V2);
    V1X = 1e3*V1X;
    V1Y = 1e3*V1Y;
    
    n = numel(kerr);
    k = logdata.sweep.rate-logdata.sweep.pause;
    k = k(1);
    m = fix(n/k);
    KERR = mean(reshape(kerr, [k, m]),1);
    KERRstd = std(reshape(kerr, [k, m]),0,1);
    CURR = mean(reshape(I, [k, m]),1);
    V0 = mean(reshape(v0, [k, m]),1);
    
    % Sample at the top of the magnet
    % 25 mT/A
    CURR = 1e-3*CURR*options.coil_const;

    yyaxis(axisA, 'left');
%       plot(axisA, CURR, KERR, 'r.-');
    errorbar(axisA, CURR, KERR, KERRstd, 'r.-', 'MarkerSize', 5);
    yyaxis(axisA, 'right');
    %plot(axisA, CURR, V0, 'b.-');
    xlabel(axisA, 'Magnetic Field, mT');

    yyaxis(axisB, 'left');
    plot(axisB, I, V1X, 'r');
    yyaxis(axisB, 'right');
    plot(axisB, I, V1Y, 'b');

    yyaxis(axisC, 'left');
    plot(axisC, I, V2X, 'r');
    yyaxis(axisC, 'right');
    plot(axisC, I, V2Y, 'b');

end