function graphics = zk(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.dT (1,1) double = 0;
    options.x1_offset (1,1) double = 0;
end

    [axisA, axisB, axisC, axisTtA, axisTtB, axisTA, axisTB, axisTC, axisTBA, axisPa, axisPb] = util.unpack(graphics.axes);
    for ax = graphics.axes
        yyaxis(ax, 'right'); cla(ax); yyaxis(ax, 'left'); cla(ax);
    end

    t = logdata.timer.time/60;      % Time, min
    TA = logdata.tempcont.A;        % Temp, K
    TB = logdata.tempcont.B;        % Temp, K
    dc = 1e3*logdata.voltmeter.v1;  % DC voltage, mV
    [x1, y1, x2, y2] = util.logdata.lockin(logdata.lockin);
    options.x1_offset = .5*1e-6;
    %options.x1_offset = 1.5*1e-6;
    if options.x1_offset
        x1 = x1 - options.x1_offset;
    end
    [V1X, V1Y, V2X, V2Y] = deal(1e3*x1, 1e3*y1, 1e3*x2, 1e3*y2);
    V2 = sqrt(V2X.^2+V2Y.^2);
    
    kerr = util.math.kerr(V1X, V2);
    V1X = 1e3*V1X;
    V1Y = 1e3*V1Y;

    % Kerr vs Time
    yyaxis(axisA, 'left');
    plot(axisA, t, kerr, 'Color', 'r');
    yyaxis(axisA, 'right');
    plot(axisA, t, dc, 'Color', 'b');

    yyaxis(axisB, 'left');
    plot(axisB, t, V1X, 'Color', 'r');
    yyaxis(axisB, 'right');
    plot(axisB, t, V1Y, 'Color', 'b');
    %V1R = sqrt(V1X.^2+V1Y.^2);
    %plot(axisB, t, V1R, 'Color', 'k');

    yyaxis(axisC, 'left');
    plot(axisC, t, V2X, 'Color', 'r');
    plot(axisC, t, V2, 'k-');
    yyaxis(axisC, 'right');
    plot(axisC, t, V2Y, 'Color', 'b');

    % Temp vs Time
    yyaxis(axisTtA, 'left');
    plot(axisTtA, t, TA, 'Color', 'r');
    yyaxis(axisTtA, 'right');
    plot(axisTtA, t, TB, 'Color', 'b');

    % Kerr vs Temp A
    yyaxis(axisTA, 'left');
    if options.dT
        [Ta, K] = util.coarse.grain(options.dT, TA, kerr);
        plot(axisTA, Ta, K, 'Color', 'r');
    else
        plot(axisTA, TA, kerr, 'Color', 'r');
    end
    yyaxis(axisTA, 'right');
    plot(axisTA, TA, dc, 'Color', 'b');

    yyaxis(axisTB, 'left');
    plot(axisTB, TA, V1X, 'Color', 'r');
    yyaxis(axisTB, 'right');
    plot(axisTB, TA, V1Y, 'Color', 'b');

    yyaxis(axisTC, 'left');
    plot(axisTC, TA, V2X, 'Color', 'r');
    yyaxis(axisTC, 'right');
    plot(axisTC, TA, V2Y, 'Color', 'b');

    % Kerr vs Temp B
    yyaxis(axisTBA, 'left');
    plot(axisTBA, TB, kerr, 'Color', 'r');
    yyaxis(axisTBA, 'right');
    plot(axisTBA, TB, dc, 'Color', 'b');

    % Kerr vs Power
    yyaxis(axisPa, 'left');
    plot(axisPa, dc, kerr, 'r.');
    yyaxis(axisPa, 'right');

    yyaxis(axisPb, 'left');
    plot(axisPb, V2, kerr, 'r.');
    yyaxis(axisPb, 'right');
    
end