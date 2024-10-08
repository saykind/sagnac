function graphics = z(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.plot_magnitude (1,1) logical = true;
end

    axisA = graphics.axes(1);
    axisB = graphics.axes(2);
    for ax = graphics.axes
        yyaxis(ax, 'left');
        cla(ax);
        yyaxis(ax, 'right');
        cla(ax);
    end

    t = logdata.timer.time/60;
    d = datetime(logdata.timer.datetime);
    d = dateshift(d,'start','minute') + seconds(round(second(d),0));
    [x1, y1, x2, y2] = util.logdata.lockin(logdata.lockin);
    [x1, y1, x2, y2] = deal(x1*1e6, y1*1e6, x2*1e3, y2*1e3);

    yyaxis(axisA, 'left');
    plot(axisA, d, x1, 'Color', 'r');

    yyaxis(axisA, 'right');
    plot(axisA, d, y1, 'Color', 'b');    

    if options.plot_magnitude
        yyaxis(axisB, 'left');
        ylabel(axisB, 'Mag, mV');
        set(axisB, 'YColor', 'k');
        plot(axisB, t, abs(x2 + 1j*y2), 'Color', 'k');

        yyaxis(axisB, 'right');
        ylabel(axisB, 'Phase (rad)');
        set(axisB, 'YColor', 'm');
        plot(axisB, t, angle(x2 + 1j*y2), 'Color', 'm');
    else
        yyaxis(axisB, 'left');
        plot(axisB, t, x2, 'Color', 'r');

        yyaxis(axisB, 'right');
        plot(axisB, t, y2, 'Color', 'b');
    end
    
end