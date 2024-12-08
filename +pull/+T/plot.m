function graphics = plot(graphics, logdata)
%Graphics plotting function.

    axisA = graphics.axes(1);
    axisB = graphics.axes(2);
    cla(axisA); cla(axisB);

    %t = logdata.watch.time/60;
    d = datetime(logdata.watch.datetime);
    d = dateshift(d,'start','minute') + seconds(round(second(d),0));
    TA = logdata.tempcont.A;
    TB = logdata.tempcont.B;

    plot(axisA, d, TA, 'Color', 'r');
    plot(axisB, d, TB, 'Color', 'b');

    % set(axisA, 'XLim', [min(t), max(t)], ...
    %     'XTick', linspace(min(t), max(t), 7));
    % set(axisB, 'XLim', [min(d), max(d)], ...
    %     'XTick', linspace(min(d), max(d), 7));
    
end