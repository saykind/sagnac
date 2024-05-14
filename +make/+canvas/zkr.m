function graphics = zkr()
%Graphics initialization function.

    f = figure('Units', 'centimeters');

    set(f,  'Position',  [0, 0, 36, 21]);
    sizeLeft = 2.5;
    sizeBottomA = 14;
    sizeBottomB = 8;
    sizeBottomC = 2;
    sizeWidth = 31;
    sizeHeight = 5;
    axesPositionA = [sizeLeft, sizeBottomA, sizeWidth, sizeHeight];
    axesPositionB = [sizeLeft, sizeBottomB, sizeWidth, sizeHeight];
    axesPositionC = [sizeLeft, sizeBottomC, sizeWidth, sizeHeight];
    sizeBottoma = 11;
    sizeBottomb = 2;
    sizeHeight2 = 7;
    axesPositiona = [sizeLeft, sizeBottoma, sizeWidth, sizeHeight2];
    axesPositionb = [sizeLeft, sizeBottomb, sizeWidth, sizeHeight2];

    tabgroup = uitabgroup(f);
    tab_time = uitab(tabgroup, 'Title', 'Kerr vs Time');
    tab_temp = uitab(tabgroup, 'Title', 'Temp vs Time');
    tab_temp_a = uitab(tabgroup, 'Title', 'Kerr vs Temp A');
    tab_power = uitab(tabgroup, 'Title', 'Kerr vs Power');
    tab_resistance = uitab(tabgroup, 'Title', 'Res vs Temp A');

    axis_time_A = axes(tab_time);
    axis_time_B = axes(tab_time);
    axis_time_C = axes(tab_time);
    axis_temp_a = axes(tab_temp);
    axis_temp_b = axes(tab_temp);
    axis_temp_A = axes(tab_temp_a);
    axis_temp_B = axes(tab_temp_a);
    axis_temp_C = axes(tab_temp_a);
    axis_power_a = axes(tab_power);
    axis_power_b = axes(tab_power);
    axis_res_a = axes(tab_resistance);
    axis_res_b = axes(tab_resistance);

    a = [axis_time_A, axis_time_B, axis_time_C, ...
            axis_temp_a, axis_temp_b, ...
            axis_temp_A, axis_temp_B, axis_temp_C, ...
            axis_power_a, axis_power_b, ...
            axis_res_a, axis_res_b];

    graphics = struct('figure', f, 'axes', a);

    for ax = a
        hold(ax, 'on');
        grid(ax, 'on');
        set(ax, 'Units', 'centimeters');
        set(ax, 'FontSize', 12, 'FontName', 'Arial');
    end
    
    title(axis_time_A, 'Time domain');
    set(axis_time_A, 'Position', axesPositionA);
    yyaxis(axis_time_A, 'right');
    set(axis_time_A, 'YColor', 'b');
    ylabel(axis_time_A, "DC Voltage, mV");
    yyaxis(axis_time_A, 'left');
    set(axis_time_A, 'YColor', 'r');
    ylabel(axis_time_A, "Kerr Signal, \murad");

    set(axis_time_B, 'Position', axesPositionB);
    set(axis_time_B, 'YColor', 'r');
    yyaxis(axis_time_B, 'right');
    set(axis_time_B, 'YColor', 'b');
    ylabel(axis_time_B, "1\omega Voltage Y, \muV");
    yyaxis(axis_time_B, 'left');
    set(axis_time_B, 'YColor', 'r');
    ylabel(axis_time_B, "1\omega Voltage X, \muV");

    set(axis_time_C, 'Position', axesPositionC);
    set(axis_time_C, 'YColor', 'r');
    yyaxis(axis_time_C, 'right');
    set(axis_time_C, 'YColor', 'b');
    ylabel(axis_time_C, "P_{2\omega}/P_0 (norm.)");
    yyaxis(axis_time_C, 'left');
    set(axis_time_C, 'YColor', 'k');
    ylabel(axis_time_C, "2\omega Voltage R, mV");
    xlabel(axis_time_C, "Time, min");

    title(axis_temp_a, 'Sample Temperature');
    set(axis_temp_a, 'Position', axesPositiona);
    yyaxis(axis_temp_a, 'right');
    set(axis_temp_a, 'YColor', 'b');
    ylabel(axis_temp_a, "Temp B, K");
    yyaxis(axis_temp_a, 'left');
    set(axis_temp_a, 'YColor', 'r');
    ylabel(axis_temp_a, "Temp A, K");

    title(axis_temp_b, 'Cryostat Temperature');
    set(axis_temp_b, 'Position', axesPositionb);
    set(axis_temp_b, 'YColor', 'r');
    yyaxis(axis_temp_b, 'right');
    set(axis_temp_b, 'YColor', 'b');
    ylabel(axis_temp_b, "Temp B, K");
    yyaxis(axis_temp_b, 'left');
    set(axis_temp_b, 'YColor', 'r');
    ylabel(axis_temp_b, "Temp A, K");
    xlabel(axis_temp_b, "Time, min");

    title(axis_temp_A, 'Temperature domain');
    set(axis_temp_A, 'Position', axesPositionA);
    yyaxis(axis_temp_A, 'right');
    set(axis_temp_A, 'YColor', 'b');
    ylabel(axis_temp_A, "DC Voltage, mV");
    yyaxis(axis_temp_A, 'left');
    set(axis_temp_A, 'YColor', 'r');
    ylabel(axis_temp_A, "Kerr Signal, \murad");

    set(axis_temp_B, 'Position', axesPositionB);
    set(axis_temp_B, 'YColor', 'r');
    yyaxis(axis_temp_B, 'right');
    set(axis_temp_B, 'YColor', 'b');
    ylabel(axis_temp_B, "1\omega Voltage Y, \muV");
    yyaxis(axis_temp_B, 'left');
    set(axis_temp_B, 'YColor', 'r');
    ylabel(axis_temp_B, "1\omega Voltage X, \muV");

    set(axis_temp_C, 'Position', axesPositionC);
    set(axis_temp_C, 'YColor', 'r');
    yyaxis(axis_temp_C, 'right');
    set(axis_temp_C, 'YColor', 'b');
    ylabel(axis_temp_C, "P_{2\omega}/P_0 (norm.)");
    yyaxis(axis_temp_C, 'left');
    set(axis_temp_C, 'YColor', 'k');
    ylabel(axis_temp_C, "2\omega Voltage R, mV");
    xlabel(axis_temp_C, "Temp, K");

    title(axis_power_a, 'Kerr vs laser diode Power');
    set(axis_power_a, 'Position', axesPositiona);
    yyaxis(axis_power_a, 'right');
    set(axis_power_a, 'YColor', 'b');
    yyaxis(axis_power_a, 'left');
    set(axis_power_a, 'YColor', 'r');
    ylabel(axis_power_a, "Kerr signal, \murad");
    xlabel(axis_power_a, "DC Voltage, mV");

    set(axis_power_b, 'Position', axesPositionb);
    set(axis_power_b, 'YColor', 'r');
    yyaxis(axis_power_b, 'right');
    set(axis_power_b, 'YColor', 'b');
    yyaxis(axis_power_b, 'left');
    set(axis_power_b, 'YColor', 'r');
    ylabel(axis_power_b, "1\omega Voltage X, \muV");
    xlabel(axis_power_b, "DC Voltage, mV");

    set(axis_res_a, 'Position', axesPositiona);
    yyaxis(axis_res_a, 'right');
    set(axis_res_a, 'YColor', 'b');
    yyaxis(axis_res_a, 'left');
    set(axis_res_a, 'YColor', 'r');
    ylabel(axis_res_a, "Resistance, m\Omega");
    xlabel(axis_res_a, "Temp A, K");

    set(axis_res_b, 'Position', axesPositionb);
    yyaxis(axis_res_b, 'right');
    set(axis_res_b, 'YColor', 'b');
    yyaxis(axis_res_b, 'left');
    set(axis_res_b, 'YColor', 'r');
    ylabel(axis_res_b, "Resistance, m\Omega");
    xlabel(axis_res_b, "Time, min");
    
    
end