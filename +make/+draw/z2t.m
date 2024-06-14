function graphics = z2t(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.dT (1,1) double = 0;
    options.x1_offset (1,1) double = 0;
end

    [axisTimeA, axisTimeB, axisTimeC, ...
        axisTimeA2, axisTimeB2, axisTimeC2, ...
        axisTempa, axisTempb, ...
        axisTempA, axisTempB, axisTempC, ...
        axisTempA2, axisTempB2, axisTempC2] = ...
        util.unpack(graphics.axes);
    for ax = graphics.axes
        yyaxis(ax, 'right'); cla(ax); yyaxis(ax, 'left'); cla(ax);
    end

    t = logdata.timer.time/60;      % Time, min
    TA = logdata.tempcont.A;        % Temp, K
    TB = logdata.tempcont.B;        % Temp, K
    dc = 1e3*logdata.voltmeter.v1;  % DC voltage, mV
    [x1, y1, x2, y2, r1, r2] = util.logdata.lockin(logdata.lockin, ...
        'scale1', 1e6, 'scale2', 1e6, 'x1_offset', options.x1_offset);
    cd = 1e3*x1./dc;    %CD * 10^6
    cd_y = 1e3*y1./dc;
    cd_r = 1e3*r1./dc;
    q1 = util.math.phase(x1, y1);  % Phase, deg
    q2 = util.math.phase(x2, y2);  % Phase, deg


    % 1f vs Time
    yyaxis(axisTimeA, 'left');
    plot(axisTimeA, t, cd, 'Color', 'r');
    yyaxis(axisTimeA, 'right');
    plot(axisTimeA, t, dc, 'Color', 'b');

    yyaxis(axisTimeB, 'left');
    plot(axisTimeB, t, x1, 'Color', 'r');
    yyaxis(axisTimeB, 'right');
    plot(axisTimeB, t, y1, 'Color', 'b');

    yyaxis(axisTimeC, 'left');
    plot(axisTimeC, t, cd_r, 'Color', 'r');
    yyaxis(axisTimeC, 'right');
    plot(axisTimeC, t, cd_y, 'Color', 'b');

    % 2f vs Time
    yyaxis(axisTimeA2, 'left');
    plot(axisTimeA2, t, r2./dc, 'Color', 'r');
    yyaxis(axisTimeA2, 'right');
    plot(axisTimeA2, t, q2, 'Color', 'b');

    yyaxis(axisTimeB2, 'left');
    plot(axisTimeB2, t, x2, 'Color', 'r');
    yyaxis(axisTimeB2, 'right');
    plot(axisTimeB2, t, y2, 'Color', 'b');

    yyaxis(axisTimeC2, 'left');
    plot(axisTimeC2, t, r2./dc, 'Color', 'r');
    yyaxis(axisTimeC2, 'right');
    plot(axisTimeC2, t, q2, 'Color', 'b');

    % Temp vs Time
    yyaxis(axisTempa, 'left');
    plot(axisTempa, t, TA, 'Color', 'r');
    yyaxis(axisTempa, 'right');
    plot(axisTempa, t, TB, 'Color', 'b');

    % 1f vs Temp A
    yyaxis(axisTempA, 'left');
    if options.dT
        [Ta, CD] = util.coarse.grain(options.dT, TA, cd);
        plot(axisTempA, Ta, CD, 'Color', 'r');
    else
        plot(axisTempA, TA, cd, 'Color', 'r');
    end
    yyaxis(axisTempA, 'right');
    plot(axisTempA, TA, dc, 'Color', 'b');

    yyaxis(axisTempB, 'left');
    plot(axisTempB, TA, x1, 'Color', 'r');
    yyaxis(axisTempB, 'right');
    plot(axisTempB, TA, y1, 'Color', 'b');

    yyaxis(axisTempC, 'left');
    plot(axisTempC, TA, cd_r, 'Color', 'r');
    yyaxis(axisTempC, 'right');
    plot(axisTempC, TA, cd_y, 'Color', 'b');

    % 2f vs Temp A
    yyaxis(axisTempA2, 'left');
    plot(axisTempA2, TA, r2./dc, 'Color', 'r');
    yyaxis(axisTempA2, 'right');
    plot(axisTempA2, TA, q2, 'Color', 'b');

    yyaxis(axisTempB2, 'left');
    plot(axisTempB2, TA, x2, 'Color', 'r');
    yyaxis(axisTempB2, 'right');
    plot(axisTempB2, TA, y2, 'Color', 'b');

    yyaxis(axisTempC2, 'left');
    plot(axisTempC2, TA, r2./dc, 'Color', 'r');
    yyaxis(axisTempC2, 'right');
    plot(axisTempC2, TA, q2, 'Color', 'b');
    
end