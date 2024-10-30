function graphics = zx()
%Graphics initialization function.

    f = figure('Units', 'centimeters');


    set(f,  'Position',  [0, 0, 26, 10]);
    tl = tiledlayout(f, 1, 1);
    axis = nexttile(tl);
    
    a = axis;
    
    hold(axis, 'on');
    grid(axis, 'on');
    set(axis, 'Units', 'centimeters');
    set(axis, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axis, 'right'); set(axis, 'YColor', 'b');
    yyaxis(axis, 'left'); set(axis, 'YColor', 'r');
    xlabel(axis, "Position, \mum");
    ylabel(axis, "Kerr \theta, \murad");
    yyaxis(axis, 'right');
    ylabel(axis, "DC power, mV");

    graphics = struct('figure', f, 'axes', a);

end