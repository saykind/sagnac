function graphics = plot(graphics, logdata)
%Graphics plotting function.

    axisA = graphics.axes(1);
    axisB = graphics.axes(2);
    for ax = [axisA, axisB]
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    
    d = datetime(logdata.watch.datetime);
    d = dateshift(d,'start','minute') + seconds(round(second(d),0));
    t = minutes(d - d(1));

    TA = logdata.tempcont.A;
    TB = logdata.tempcont.B;
    C = logdata.bridge.C;             % Capacitance, pF
    strain = util.strain.from_capacitance(C, TA, d0_sample=985);

    yyaxis(axisA, 'right');
    plot(axisA, t, C, 'Color', 'b');
    yyaxis(axisA, 'left');
    plot(axisA, t, strain, 'Color', 'r');

    yyaxis(axisB, 'right');
    plot(axisB, d, TB, 'Color', 'b');
    yyaxis(axisB, 'left');
    plot(axisB, d, TA, 'Color', 'r');
    
end