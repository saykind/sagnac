function graphics = zi()
%Graphics initialization function.

    f = figure('Units', 'centimeters');

    set(f,  'Position',  [0, 0, 24, 20]);
    tabgroup = uitabgroup(f);
    tab_current = uitab(tabgroup, 'Title', 'Current sweep');
    tab_power = uitab(tabgroup, 'Title', 'Power sweep');

    tl_current = tiledlayout(tab_current, 3, 1);
    tl_current.TileSpacing = 'compact';
    tl_current.Padding = 'compact';

    tl_power = tiledlayout(tab_power, 3, 1);
    tl_power.TileSpacing = 'compact';
    tl_power.Padding = 'compact';

    axis_current_A = nexttile(tl_current);
    axis_current_B = nexttile(tl_current);
    axis_current_C = nexttile(tl_current);

    axis_power_A = nexttile(tl_power);
    axis_power_B = nexttile(tl_power);
    axis_power_C = nexttile(tl_power);

    a = [axis_current_A, axis_current_B, axis_current_C, ....
            axis_power_A, axis_power_B, axis_power_C];

    for ax = a
        hold(ax, 'on');
        grid(ax, 'on');
        set(ax, 'Units', 'centimeters');
        set(ax, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(ax, 'right');
        set(ax, 'YColor', 'b');
        yyaxis(ax, 'left');
        set(ax, 'YColor', 'r');
    end

    % Current axis
    title(axis_current_A, 'Laser intensity sweep');

    yyaxis(axis_current_A, 'right');
    ylabel(axis_current_A, "DC Voltage, mV");
    yyaxis(axis_current_A, 'left');
    ylabel(axis_current_A, "Kerr, \murad");

    yyaxis(axis_current_B, 'right');
    ylabel(axis_current_B, "1\omega Y, \muV");
    yyaxis(axis_current_B, 'left');
    ylabel(axis_current_B, "1\omega X, \muV");

    yyaxis(axis_current_C, 'right');
    ylabel(axis_current_C, "2\omega V_{2Y}, mV");
    yyaxis(axis_current_C, 'left');
    ylabel(axis_current_C, "2\omega V_{2X}, mV");

    xlabel(axis_current_C, "Laser diode current, mA");

    % Power axis
    title(axis_power_A, 'Laser intensity sweep');

    yyaxis(axis_power_A, 'left');
    ylabel(axis_power_A, "Kerr, \murad");

    yyaxis(axis_power_B, 'right');
    ylabel(axis_power_B, "1\omega Y, \muV");
    yyaxis(axis_power_B, 'left');
    ylabel(axis_power_B, "1\omega X, \muV");

    yyaxis(axis_power_C, 'left');
    ylabel(axis_power_C, "2\omega Magnitude, mV");
    yyaxis(axis_power_C, 'right');
    ylabel(axis_power_C, "1\omega Magnitude, mV");

    xlabel(axis_power_C, "DC voltage, mV");

    graphics = struct('figure', f, 'axes', a);

end