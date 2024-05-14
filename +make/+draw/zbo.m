function graphics = zbo(graphics, logdata)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
end

    [axisA, axisB] = util.graphics.unpack(graphics.axes);

    % t = logdata.timer.time/60;             % time, min
    v0 = logdata.sweep.range;               % sweep voltage, V
    p  = 10*logdata.bcb.optical_power;      % optical power, uW, assuming 10% tap
    dc = logdata.voltmeter.v1/0.9*1e2;       % DC voltage, uW, assuming 10% tap
    if isempty(dc), return; end
    x1 = 1e6*logdata.lockin.x(:,1);        % 1st harmonic X, V
    y1 = 1e6*logdata.lockin.y(:,1);        % 1st harmonic Y, V
    x2 = 1e6*logdata.lockin.x(:,2);        % 2nd harmonic X, V
    y2 = 1e6*logdata.lockin.y(:,2);        % 2nd harmonic Y, V
    r2 = sqrt(x2.^2 + y2.^2);               % 2nd harmonic R, V
    r1 = sqrt(x1.^2 + y1.^2);               % 1st harmonic R, V
    q1 = atan2(y1, x1);                     % 1st harmonic Q, rad
    v0 = v0(1:length(dc));

    % [DC, X1, Y1, R1] = util.coarse.sweep(logdata.sweep, dc, x1, y1, r1);
    % V0 = v0(1:length(DC));

    yyaxis(axisA, 'left');
    plot(axisA, v0, p, "Color", "r");
    yyaxis(axisA, 'right');
    plot(axisA, v0, dc, "Color", "b");

    yyaxis(axisB, 'left');
    plot(axisB, v0, r1, "Color", "r");
    yyaxis(axisB, 'right');
    plot(axisB, v0, r2, "Color", "b");
    
end