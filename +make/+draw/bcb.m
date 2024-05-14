function graphics = bcb(graphics, logdata)
%Graphics plotting function.

    axisA = graphics.axes(1);
    axisB = graphics.axes(2);
    cla(axisA); cla(axisB);

    t = logdata.timer.time/60;
    d = datetime(logdata.timer.datetime);
    d = dateshift(d,'start','minute') + seconds(round(second(d),0));
    v = logdata.bcb.voltage;
    p = logdata.bcb.optical_power;

    plot(axisA, t, v, 'Color', 'r');
    plot(axisB, d, p, 'Color', 'b');

    set(axisA, 'XLim', [min(t), max(t)], ...
        'XTick', linspace(min(t), max(t), 7));
    set(axisB, 'XLim', [min(d), max(d)], ...
        'XTick', linspace(min(d), max(d), 7));
    
end