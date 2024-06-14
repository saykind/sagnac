function graphics = zk(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.dT (1,1) double = 0;
    options.x1_offset (1,1) double = 0;
end
    %options.x1_offset = .43*1e-6;
    %options.x1_offset = 1.5*1e-6;

    [axisA, axisB, axisC, axisTtA, axisTtB, axisTA, axisTB, axisTC, axisTBA, axisPa, axisPb] = util.unpack(graphics.axes);
    for ax = graphics.axes
        yyaxis(ax, 'right'); cla(ax); yyaxis(ax, 'left'); cla(ax);
    end

    t = logdata.timer.time/60;      % Time, min
    TA = logdata.tempcont.A;        % Temp, K
    TB = logdata.tempcont.B;        % Temp, K
    dc = 1e3*logdata.voltmeter.v1;  % DC voltage, mV
    [x1, y1, x2, y2, r1, r2, kerr] = util.logdata.lockin(logdata.lockin, 'x1_offset', options.x1_offset);
    
    %r1 = sqrt(x1.^2 + y1.^2);
    %x5 = 1e6*logdata.lockin.x(:,5);
    %y5 = 1e6*logdata.lockin.y(:,5);
    %r5 = sqrt(x5.^2 + y5.^2);

    % Kerr vs Time
    yyaxis(axisA, 'left');
    plot(axisA, t, kerr, 'Color', 'r');
    yyaxis(axisA, 'right');
    plot(axisA, t, dc, 'Color', 'b');

    yyaxis(axisB, 'left');
    plot(axisB, t, x1, 'Color', 'r');
    yyaxis(axisB, 'right');
    plot(axisB, t, y1, 'Color', 'b');

    yyaxis(axisC, 'left');
    plot(axisC, t, r2, 'Color', 'r');
    %plot(axisC, t, r2, 'k-');

    coeff = besselj(2,2*.92)/(1+besselj(0,2*.92))*(.673/.25);
    yyaxis(axisC, 'right');
    plot(axisC, t, r2./dc/coeff, 'Color', 'b');

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
    plot(axisTB, TA, x1, 'Color', 'r');
    yyaxis(axisTB, 'right');
    plot(axisTB, TA, y1, 'Color', 'b');

    yyaxis(axisTC, 'left');
    plot(axisTC, TA, r2, 'Color', 'k');
    yyaxis(axisTC, 'right');
    plot(axisTC, TA, y2, 'Color', 'b');

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
    plot(axisPb, dc, x1, 'r.');
    yyaxis(axisPb, 'right');
    
end