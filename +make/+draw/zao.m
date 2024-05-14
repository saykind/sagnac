function graphics = zao(graphics, logdata)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
end

    [axisA, axisB] = util.graphics.unpack(graphics.axes);

    v0 = logdata.sweep.range;           % offset voltage, V
    dc = 1e3*logdata.voltmeter.v1;      % DC voltage, mV
    x1 = 1e6*logdata.lockin.x(:,1);     % 1st harmonic X, uV
    y1 = 1e6*logdata.lockin.y(:,1);     % 1st harmonic Y, uV
    r1 = sqrt(x1.^2 + y1.^2);           % 1st harmonic R, uV

    [DC, X1, Y1, R1] = util.coarse.sweep(logdata.sweep, dc, x1, y1, r1);
    V0 = v0(1:length(DC));

    yyaxis(axisA, 'left');
    plot(axisA, V0, R1, 'Color', 'r');

    yyaxis(axisA, 'right');
    plot(axisA, V0, DC, 'Color', 'b');    

    yyaxis(axisB, 'left');
    plot(axisB, V0, X1, 'Color', 'r');

    yyaxis(axisB, 'right');
    plot(axisB, V0, Y1, 'Color', 'b');
    
end