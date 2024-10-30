function graphics = zkg()
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
    sizeBottom = 2;
    sizeHeight2 = 17;
    axesPosition0 = [sizeLeft, sizeBottom, sizeWidth, sizeHeight2];

    tabgroup = uitabgroup(f);
        tabTime = uitab(tabgroup, 'Title', 'Kerr vs Time');
        tabTemp = uitab(tabgroup, 'Title', 'Temp vs Time');
        tabKerrSource = uitab(tabgroup, 'Title', 'Kerr vs Gate');
        tabKerrTemp = uitab(tabgroup, 'Title', 'Kerr vs Temp');
        tabPower = uitab(tabgroup, 'Title', 'Kerr vs Power');
        tabTransA = uitab(tabgroup, 'Title', 'Transport A');
        tabTransB = uitab(tabgroup, 'Title', 'Transport B');

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

        axisKerrGateA = axes(tabKerrSource);
        hold(axisKerrGateA, 'on');
        grid(axisKerrGateA, 'on');
        title(axisKerrGateA, 'Gate voltage sweep');
        set(axisKerrGateA, 'Units', 'centimeters');
        set(axisKerrGateA, 'Position', axesPositionA);
        set(axisKerrGateA, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisKerrGateA, 'right');
        set(axisKerrGateA, 'YColor', 'b');
        ylabel(axisKerrGateA, "DC Voltage, mV");
        yyaxis(axisKerrGateA, 'left');
        set(axisKerrGateA, 'YColor', 'r');
        ylabel(axisKerrGateA, "Kerr Signal, \murad");

        axisKerrGateB = axes(tabKerrSource);
        hold(axisKerrGateB, 'on');
        grid(axisKerrGateB, 'on');
        set(axisKerrGateB, 'Units', 'centimeters');
        set(axisKerrGateB, 'Position', axesPositionB);
        set(axisKerrGateB, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
        set(axisKerrGateB, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisKerrGateB, 'right');
        set(axisKerrGateB, 'YColor', 'b');
        ylabel(axisKerrGateB, "1\omega Voltage Y, \muV");
        yyaxis(axisKerrGateB, 'left');
        set(axisKerrGateB, 'YColor', 'r');
        ylabel(axisKerrGateB, "1\omega Voltage X, \muV");

        axisKerrGateC = axes(tabKerrSource);
        hold(axisKerrGateC, 'on');
        grid(axisKerrGateC, 'on');
        set(axisKerrGateC, 'Units', 'centimeters');
        set(axisKerrGateC, 'Position', axesPositionC);
        set(axisKerrGateC, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
        set(axisKerrGateC, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisKerrGateC, 'right');
        set(axisKerrGateC, 'YColor', 'b');
        ylabel(axisKerrGateC, "2\omega Voltage Y, mV");
        yyaxis(axisKerrGateC, 'left');
        set(axisKerrGateC, 'YColor', 'r');
        ylabel(axisKerrGateC, "2\omega Voltage X, mV");
        xlabel(axisKerrGateC, "Gate Voltage, V");

        axisTempBa = axes(tabKerrTemp);
        hold(axisTempBa, 'on');
        grid(axisTempBa, 'on');
        title(axisTempBa, 'Temperature domain');
        set(axisTempBa, 'Units', 'centimeters');
        set(axisTempBa, 'Position', axesPosition0);
        set(axisTempBa, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisTempBa, 'right');
        set(axisTempBa, 'YColor', 'b');
        ylabel(axisTempBa, "DC Voltage, mV");
        yyaxis(axisTempBa, 'left');
        set(axisTempBa, 'YColor', 'r');
        ylabel(axisTempBa, "Kerr Signal, \murad");
        xlabel(axisTempBa, "Temp A, K");

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
        
        axisTrA = axes(tabTransA);
        hold(axisTrA, 'on');
        grid(axisTrA, 'on');
        title(axisTrA, 'Transport A');
        set(axisTrA, 'Units', 'centimeters');
        set(axisTrA, 'Position', axesPosition0);
        set(axisTrA, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisTrA, 'right');
        set(axisTrA, 'YColor', 'b');
        yyaxis(axisTrA, 'left');
        set(axisTrA, 'YColor', 'r');
        ylabel(axisTrA, "Lockin_A, nA");
        xlabel(axisTrA, "Gate voltage, V");
        
        axisTrB = axes(tabTransB);
        hold(axisTrB, 'on');
        grid(axisTrB, 'on');
        title(axisTrB, 'Transport B');
        set(axisTrB, 'Units', 'centimeters');
        set(axisTrB, 'Position', axesPosition0);
        set(axisTrB, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisTrB, 'right');
        set(axisTrB, 'YColor', 'b');
        yyaxis(axisTrB, 'left');
        set(axisTrB, 'YColor', 'r');
        ylabel(axisTrB, "Lockin_B X, \muV");
        xlabel(axisTrB, "Gate voltage, V");

        a = [axisTimeA, axisTimeB, axisTimeC, ...
             axisTempa, axisTempb, ...
             axisKerrGateA, axisKerrGateB, axisKerrGateC, ...
             axisTempBa, ...
             axisPowera, axisPowerb, ...
             axisTrA, ...
             axisTrB];

    graphics = struct('figure', f, 'axes', a);

end