function graphics = bco(graphics, logdata)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
end

    axisA = graphics.axes(1);
    axisB = graphics.axes(2);
    cla(axisA);
    cla(axisB);

    t = logdata.timer.time/60;          % time, min
    v0 = logdata.sweep.range;           % offset voltage, V
    v = logdata.bcb.voltage;            % BCB voltage, V
    p = logdata.bcb.optical_power;              % BCB power, uW

    %[DC, X1, Y1, R1] = util.coarse.sweep(logdata.sweep, dc, x1, y1, r1);
    %V0 = v0(1:length(DC));

    plot(axisA, t, v, "Color", "k");

    plot(axisB, v, p, "Color", "r");

    
end