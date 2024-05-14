function graphics = zao()
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
        yyaxis(ax, 'right'); set(ax, 'YColor', 'b');
        yyaxis(ax, 'left'); set(ax, 'YColor', 'r');
    end

    xlabel(axisA, "Offset voltage, V");
    yyaxis(axisA, 'left');
    ylabel(axisA, "1\omega R, uV");
    yyaxis(axisA, 'right');
    ylabel(axisA, "DC, mV");

    xlabel(axisB, "Offset voltage, V");
    yyaxis(axisB, 'left');
    ylabel(axisB, "1\omega X, uV");
    yyaxis(axisB, 'right');
    ylabel(axisB, "1\omega Y, uV");

    graphics = struct('figure', f, 'axes', a);

end