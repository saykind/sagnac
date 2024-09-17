function graphics = rsv()
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
    xlabel(axisA, "25*AUXV1, V");
    ylabel(axisA, "Resistance, mOhm");
    hold(axisA, 'on'); 
    a = axisA;

    graphics = struct('figure', f, 'axes', a);

end