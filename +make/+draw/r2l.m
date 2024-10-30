function graphics = r2l(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.dT (1,1) double = 0;
end

    [axisA, axisB, axisC, axisTtA, axisTtB, axisTA, axisTB, axisTC] = util.unpack(graphics.axes);
    for ax = graphics.axes
        yyaxis(ax, 'right'); cla(ax); yyaxis(ax, 'left'); cla(ax);
    end

    t = logdata.timer.time/60;      % Time, min
    TA = logdata.tempcont.A;        % Temp, K
    TB = logdata.tempcont.B;        % Temp, K
    TempA = logdata.temp.A;         % Temp, K
    TempB = logdata.temp.B;         % Temp, K

    vAx = logdata.lockinA.X;        % Voltage, uV
    vAy = logdata.lockinA.Y;        % Voltage, uV
    vBx = logdata.lockinB.X;        % Voltage, uV
    vBy = logdata.lockinB.Y;        % Voltage, uV

    currA = 1e-9;  % 10 mV, 100 MOhm
    currB = 1e-9;   % 10 mV, 10 MOhm

    vAx = 1e-3*vAx/currA; % Resistance, kOhm
    vAy = 1e-3*vAy/currA; % Resistance, kOhm
    vBx = 1e-3*vBx/currB; % Resistance, kOhm
    vBy = 1e-3*vBy/currB; % Resistance, kOhm

    % Transport vs Time
    yyaxis(axisA, 'left');
    plot(axisA, t, vAx, 'Color', 'r');
    yyaxis(axisA, 'right');
    plot(axisA, t, vAy, 'Color', 'b');

    yyaxis(axisB, 'left');
    plot(axisB, t, vBx, 'Color', 'r');
    yyaxis(axisB, 'right');
    plot(axisB, t, vBy, 'Color', 'b');

    yyaxis(axisC, 'left');
    %plot(axisC, t, r2, 'Color', 'r');

    % Temp vs Time
    yyaxis(axisTtA, 'left');
    plot(axisTtA, t, TA, 'Color', 'r');
    yyaxis(axisTtA, 'right');
    plot(axisTtA, t, TB, 'Color', 'b');

    yyaxis(axisTtB, 'left');
    plot(axisTtB, t, TempA, 'Color', 'r');
    yyaxis(axisTtB, 'right');
    plot(axisTtB, t, TempB, 'Color', 'b');

    % Transport vs Temp A
    yyaxis(axisTA, 'left');
    plot(axisTA, TA, vAx, 'Color', 'r');
    yyaxis(axisTA, 'right');
    plot(axisTA, TA, vAy, 'Color', 'b');

    yyaxis(axisTB, 'left');
    plot(axisTB, TA, vBx, 'Color', 'r');
    yyaxis(axisTB, 'right');
    plot(axisTB, TA, vBy, 'Color', 'b');
    
end