function graphics = zbo()
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

    xlabel(axisA, "Offset voltage, V");
    yyaxis(axisA, 'left');
    set(axisA, 'YColor', 'r');
    ylabel(axisA, "Optical power (BCB), uW");
    yyaxis(axisA, 'right');
    set(axisA, 'YColor', 'b');
    ylabel(axisA, "Optical power (total), uW");

    xlabel(axisB, "Offset voltage, V");
    yyaxis(axisB, 'left');
    set(axisB, 'YColor', 'r');
    ylabel(axisB, "1\omega R, uV");
    yyaxis(axisB, 'right');
    set(axisB, 'YColor', 'b');
    ylabel(axisB, "2\omega R, uV");

    graphics = struct('figure', f, 'axes', a);

end