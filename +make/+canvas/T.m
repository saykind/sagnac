function graphics = T()
%Graphics initialization function.

    f = figure('Units', 'centimeters');

    set(f,  'Position',  [0, 0, 25, 10]);
    t = tiledlayout(f,1,1);
    axisA = axes(t, ...
        'FontSize', 12, ...
        'FontName', 'Arial', ...
        'XGrid', 'on', ...
        'YGrid', 'on', ...
        'Box', 'off', ...
        'YColor', 'r');
    xlabel(axisA, "Time, min");
    ylabel(axisA, "Temp A, K");
    axisB = axes(t, ...
        'FontSize', 12, ...
        'FontName', 'Arial', ...
        'XGrid', 'on', ...
        'YGrid', 'on', ...
        'Box', 'off', ...
        'Color', 'none', ...
        'XAxisLocation', 'top', ...
        'YAxisLocation', 'right', ...
        'YColor', 'b');
    ylabel(axisB, "Temp B, K");
    hold(axisA, 'on'); 
    hold(axisB, 'on');
    xtickformat(axisA, '%.0f');
    a = [axisA, axisB];

    graphics = struct('figure', f, 'axes', a);

end