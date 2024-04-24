function graphics = z1(graphics, logdata)
%Graphics plotting function.

    axisA = graphics.axes(1);
    axisB = graphics.axes(2);
    cla(axisA); cla(axisB);

    t = logdata.timer.time/60;
    d = datetime(logdata.timer.datetime);
    d = dateshift(d,'start','minute') + seconds(round(second(d),0));
    x = 1e6*logdata.lockin.x(:,1);
    y = 1e6*logdata.lockin.y(:,1);

    plot(axisA, t, x, 'Color', 'r');
    plot(axisB, d, y, 'Color', 'b');

    set(axisA, 'XLim', [min(t), max(t)], ...
        'XTick', linspace(min(t), max(t), 7));
    set(axisB, 'XLim', [min(d), max(d)], ...
        'XTick', linspace(min(d), max(d), 7));
    
end