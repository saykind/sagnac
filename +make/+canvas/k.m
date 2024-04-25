function graphics = k()
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
    tabTime = uitab(tabgroup, 'Title', 'Kerr vs Time');
    tabTemp = uitab(tabgroup, 'Title', 'Temp vs Time');
    tabTempA = uitab(tabgroup, 'Title', 'Kerr vs Temp A');
    tabTempB = uitab(tabgroup, 'Title', 'Kerr vs Temp B');
    tabPower = uitab(tabgroup, 'Title', 'Kerr vs Power');

    axisTimeA = axes(tabTime);
    hold(axisTimeA, 'on');
    grid(axisTimeA, 'on');
    title(axisTimeA, 'Time domain');
    set(axisTimeA, 'Units', 'centimeters');
    set(axisTimeA, 'Position', axesPositionA);
    set(axisTimeA, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTimeA, 'right');
    set(axisTimeA, 'YColor', 'b');
    ylabel(axisTimeA, "DC Voltage, mV");
    yyaxis(axisTimeA, 'left');
    set(axisTimeA, 'YColor', 'r');
    ylabel(axisTimeA, "Kerr Signal, \murad");

    axisTimeB = axes(tabTime);
    hold(axisTimeB, 'on');
    grid(axisTimeB, 'on');
    set(axisTimeB, 'Units', 'centimeters');
    set(axisTimeB, 'Position', axesPositionB);
    set(axisTimeB, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
    set(axisTimeB, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTimeB, 'right');
    set(axisTimeB, 'YColor', 'b');
    ylabel(axisTimeB, "1\omega Voltage Y, \muV");
    yyaxis(axisTimeB, 'left');
    set(axisTimeB, 'YColor', 'r');
    ylabel(axisTimeB, "1\omega Voltage X, \muV");

    axisTimeC = axes(tabTime);
    hold(axisTimeC, 'on');
    grid(axisTimeC, 'on');
    set(axisTimeC, 'Units', 'centimeters');
    set(axisTimeC, 'Position', axesPositionC);
    set(axisTimeC, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
    set(axisTimeC, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTimeC, 'right');
    set(axisTimeC, 'YColor', 'b');
    ylabel(axisTimeC, "2\omega Voltage Y, mV");
    yyaxis(axisTimeC, 'left');
    set(axisTimeC, 'YColor', 'r');
    ylabel(axisTimeC, "2\omega Voltage X, mV");
    xlabel(axisTimeC, "Time, min");

    axisTempa = axes(tabTemp);
    hold(axisTempa, 'on');
    grid(axisTempa, 'on');
    title(axisTempa, 'Sample Temperature');
    set(axisTempa, 'Units', 'centimeters');
    set(axisTempa, 'Position', axesPositiona);
    set(axisTempa, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTempa, 'right');
    set(axisTempa, 'YColor', 'b');
    ylabel(axisTempa, "Temp B, K");
    yyaxis(axisTempa, 'left');
    set(axisTempa, 'YColor', 'r');
    ylabel(axisTempa, "Temp A, K");

    axisTempb = axes(tabTemp);
    hold(axisTempb, 'on');
    grid(axisTempb, 'on');
    title(axisTempb, 'Cryostat Temperature');
    set(axisTempb, 'Units', 'centimeters');
    set(axisTempb, 'Position', axesPositionb);
    set(axisTempb, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
    set(axisTempb, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTempb, 'right');
    set(axisTempb, 'YColor', 'b');
    ylabel(axisTempb, "Temp B, K");
    yyaxis(axisTempb, 'left');
    set(axisTempb, 'YColor', 'r');
    ylabel(axisTempb, "Temp A, K");
    xlabel(axisTempb, "Time, min");

    axisTempA = axes(tabTempA);
    hold(axisTempA, 'on');
    grid(axisTempA, 'on');
    title(axisTempA, 'Temperature domain');
    set(axisTempA, 'Units', 'centimeters');
    set(axisTempA, 'Position', axesPositionA);
    set(axisTempA, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTempA, 'right');
    set(axisTempA, 'YColor', 'b');
    ylabel(axisTempA, "DC Voltage, mV");
    yyaxis(axisTempA, 'left');
    set(axisTempA, 'YColor', 'r');
    ylabel(axisTempA, "Kerr Signal, \murad");

    axisTempB = axes(tabTempA);
    hold(axisTempB, 'on');
    grid(axisTempB, 'on');
    set(axisTempB, 'Units', 'centimeters');
    set(axisTempB, 'Position', axesPositionB);
    set(axisTempB, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
    set(axisTempB, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTempB, 'right');
    set(axisTempB, 'YColor', 'b');
    ylabel(axisTempB, "1\omega Voltage Y, \muV");
    yyaxis(axisTempB, 'left');
    set(axisTempB, 'YColor', 'r');
    ylabel(axisTempB, "1\omega Voltage X, \muV");

    axisTempC = axes(tabTempA);
    hold(axisTempC, 'on');
    grid(axisTempC, 'on');
    set(axisTempC, 'Units', 'centimeters');
    set(axisTempC, 'Position', axesPositionC);
    set(axisTempC, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
    set(axisTempC, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTempC, 'right');
    set(axisTempC, 'YColor', 'b');
    ylabel(axisTempC, "2\omega Voltage Y, mV");
    yyaxis(axisTempC, 'left');
    set(axisTempC, 'YColor', 'r');
    ylabel(axisTempC, "2\omega Voltage X, mV");
    xlabel(axisTempC, "Temp, K");

    axisTempBa = axes(tabTempB);
    hold(axisTempBa, 'on');
    grid(axisTempBa, 'on');
    title(axisTempBa, 'Temperature domain');
    set(axisTempBa, 'Units', 'centimeters');
    set(axisTempBa, 'Position', axesPositionA);
    set(axisTempBa, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTempBa, 'right');
    set(axisTempBa, 'YColor', 'b');
    ylabel(axisTempBa, "DC Voltage, mV");
    yyaxis(axisTempBa, 'left');
    set(axisTempBa, 'YColor', 'r');
    ylabel(axisTempBa, "Kerr Signal, \murad");
    xlabel(axisTempBa, "Temp B, K");

    axisPowera = axes(tabPower);
    hold(axisPowera, 'on');
    grid(axisPowera, 'on');
    title(axisPowera, 'Kerr vs laser diode Power');
    set(axisPowera, 'Units', 'centimeters');
    set(axisPowera, 'Position', axesPositiona);
    set(axisPowera, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisPowera, 'right');
    set(axisPowera, 'YColor', 'b');
    yyaxis(axisPowera, 'left');
    set(axisPowera, 'YColor', 'r');
    ylabel(axisPowera, "Kerr signal, \murad");
    xlabel(axisPowera, "DC Voltage, mV");

    axisPowerb = axes(tabPower);
    hold(axisPowerb, 'on');
    grid(axisPowerb, 'on');
    set(axisPowerb, 'Units', 'centimeters');
    set(axisPowerb, 'Position', axesPositionb);
    set(axisPowerb, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
    set(axisPowerb, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisPowerb, 'right');
    set(axisPowerb, 'YColor', 'b');
    yyaxis(axisPowerb, 'left');
    set(axisPowerb, 'YColor', 'r');
    ylabel(axisPowerb, "Kerr signal, \murad");
    xlabel(axisPowerb, "2\omega Magnitude, mV");

    a = [axisTimeA, axisTimeB, axisTimeC, ...
            axisTempa, axisTempb, ...
            axisTempA, axisTempB, axisTempC, ...
            axisTempBa, ...
            axisPowera, axisPowerb];

    graphics = struct('figure', f, 'axes', a);

end