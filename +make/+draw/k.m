function graphics = k(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.calculate_sls (1,1) logical = false;
end

    [axisA, axisB, axisC, axisTtA, axisTtB, axisTA, axisTB, axisTC, axisTBA, axisPa, axisPb] = util.graphics.unpack(graphics.axes);
    for ax = graphics.axes
        cla(ax); yyaxis(ax, 'left'); cla(ax);
    end

    t = logdata.timer.time/60;      % Time, min
    TA = logdata.tempcont.A;        % Temp, K
    TB = logdata.tempcont.B;        % Temp, K
    dc = 1e3*logdata.voltmeter.v1;  % DC voltage, mV
    V1X = 1e3*logdata.lockin.X;     % 1st harm Voltage X, uV
    V1Y = 1e3*logdata.lockin.Y;     % 1st harm Voltage Y, uV
    V2X = 1e3*logdata.lockin.AUX1;  % 2nd harm Voltage X, mV
    V2Y = 1e3*logdata.lockin.AUX2;  % 2nd harm Voltage Y, mV
    V2 = sqrt(V2X.^2+V2Y.^2);

    if options.calculate_sls
        try
            sls = util.data.sls(dc, V2);
            disp(sls);
        catch
            disp("Wasn't able to find correct lockin sensitivity;")
        end
    else
        sls = .1;
    end
    V2X = sls*V2X;
    V2Y = sls*V2Y;
    V2 = sls*V2;

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
    plot(axisTA, TA, kerr, 'Color', 'r');
    yyaxis(axisTA, 'right');
    plot(axisTA, TA, dc, 'Color', 'b');

    yyaxis(axisTB, 'left');
    plot(axisTB, TA, V1X, 'Color', 'r');
    yyaxis(axisTB, 'right');
    plot(axisTB, TA, V1Y, 'Color', 'b');

    yyaxis(axisTC, 'left');
    plot(axisTC, TA, V2X, 'Color', 'r');
    %plot(axisTC, TA, V2, 'k-');
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