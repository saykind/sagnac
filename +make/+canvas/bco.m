function graphics = bco()
%Graphics initialization function.

    f = figure('Units', 'centimeters');

    set(f,  'Position',  [0, 0, 25, 22]);
    tl = tiledlayout(f,2,1);
    axisA = nexttile(tl);
    axisB = nexttile(tl);
    a = [axisA, axisB];
    for ax = a
        set(ax, ...
            'FontSize', 12, ...
            'FontName', 'Arial', ...
            'XGrid', 'on', ...
            'YGrid', 'on');
        hold(ax, 'on');
    end

    xlabel(axisA, "Time, min");
    ylabel(axisA, "Offset voltage, V");

    xlabel(axisB, "Offset voltage, V");
    ylabel(axisB, "Optical power, uW");

    graphics = struct('figure', f, 'axes', a);

end