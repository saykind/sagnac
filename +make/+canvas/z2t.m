function graphics = zk()
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
    tabTime = uitab(tabgroup, 'Title', '1f vs Time');
    tabTime2 = uitab(tabgroup, 'Title', '2f vs Time');
    tabTemp = uitab(tabgroup, 'Title', 'Temp vs Time');
    tabTempA = uitab(tabgroup, 'Title', '1f vs Temp A');
    tabTempA2 = uitab(tabgroup, 'Title', '2f vs Temp A');

    axisTimeA = axes(tabTime);
    axisTimeB = axes(tabTime);
    axisTimeC = axes(tabTime);

    axisTimeA2 = axes(tabTime2);
    axisTimeB2 = axes(tabTime2);
    axisTimeC2 = axes(tabTime2);

    axisTempa = axes(tabTemp);
    axisTempb = axes(tabTemp);

    axisTempA = axes(tabTempA);
    axisTempB = axes(tabTempA);
    axisTempC = axes(tabTempA);

    axisTempA2 = axes(tabTempA2);
    axisTempB2 = axes(tabTempA2);
    axisTempC2 = axes(tabTempA2);

    a = [axisTimeA, axisTimeB, axisTimeC, ...
            axisTimeA2, axisTimeB2, axisTimeC2, ...
            axisTempa, axisTempb, ...
            axisTempA, axisTempB, axisTempC, ...
            axisTempA2, axisTempB2, axisTempC2];

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

    % Time domain 1f
    title(axisTimeA, 'Time domain');
    set(axisTimeA, 'Position', axesPositionA);
    yyaxis(axisTimeA, 'right');
    ylabel(axisTimeA, "DC Voltage, mV");
    yyaxis(axisTimeA, 'left');
    ylabel(axisTimeA, "10^6 X_{1\omega}/DC");

    set(axisTimeB, 'Position', axesPositionB);
    yyaxis(axisTimeB, 'right');
    ylabel(axisTimeB, "Y_{1\omega}, \muV");
    yyaxis(axisTimeB, 'left');
    ylabel(axisTimeB, "X_{1\omega}, \muV");

    set(axisTimeC, 'Position', axesPositionC);
    yyaxis(axisTimeC, 'right');
    ylabel(axisTimeC, "10^6 Y_{1\omega}/DC");
    yyaxis(axisTimeC, 'left');
    ylabel(axisTimeC, "10^6 R_{1\omega}/DC");

    xlabel(axisTimeC, "Time, min");

    % Time domain 2f
    title(axisTimeA2, 'Time domain');
    set(axisTimeA2, 'Position', axesPositionA);
    yyaxis(axisTimeA2, 'right');
    ylabel(axisTimeA2, "DC Voltage, mV");
    yyaxis(axisTimeA2, 'left');
    ylabel(axisTimeA2, "10^6 X_{2\omega}/DC");

    set(axisTimeB2, 'Position', axesPositionB);
    yyaxis(axisTimeB2, 'right');
    ylabel(axisTimeB2, "Y_{2\omega}, \muV");
    yyaxis(axisTimeB2, 'left');
    ylabel(axisTimeB2, "X_{2\omega}, \muV");

    set(axisTimeC2, 'Position', axesPositionC);
    yyaxis(axisTimeC2, 'right');
    ylabel(axisTimeC2, "Q_{2\omega}, deg");
    yyaxis(axisTimeC2, 'left');
    ylabel(axisTimeC2, "10^6 R_{2\omega}/DC, \muV");

    xlabel(axisTimeC2, "Time, min");

    
    % Temp vs Time
    title(axisTempa, 'Sample Temperature');
    set(axisTempa, 'Position', axesPositiona);
    yyaxis(axisTempa, 'right');
    ylabel(axisTempa, "Temp B, K");
    yyaxis(axisTempa, 'left');
    ylabel(axisTempa, "Temp A, K");

    title(axisTempb, 'Cryostat Temperature');
    set(axisTempb, 'Position', axesPositionb);
    yyaxis(axisTempb, 'right');
    ylabel(axisTempb, "Temp B, K");
    yyaxis(axisTempb, 'left');
    ylabel(axisTempb, "Temp A, K");

    xlabel(axisTempb, "Time, min");

    
    % Temp domain 1f
    title(axisTempA, 'Temperature domain');
    set(axisTempA, 'Position', axesPositionA);
    yyaxis(axisTempA, 'right');
    ylabel(axisTempA, "DC Voltage, mV");
    yyaxis(axisTempA, 'left');
    ylabel(axisTempA, "10^6 X_{1\omega}/DC");
    
    set(axisTempB, 'Position', axesPositionB);
    yyaxis(axisTempB, 'right');
    ylabel(axisTempB, "Y_{1\omega}, \muV");
    yyaxis(axisTempB, 'left');
    ylabel(axisTempB, "X_{1\omega}, \muV");

    set(axisTempC, 'Position', axesPositionC);
    yyaxis(axisTempC, 'right');
    ylabel(axisTempC, "10^6 Y_{1\omega}/DC");
    yyaxis(axisTempC, 'left');
    ylabel(axisTempC, "10^6 R_{1\omega}/DC");

    xlabel(axisTempC, "Temp, K");

    % Temp domain 2f
    title(axisTempA2, 'Temperature domain');
    set(axisTempA2, 'Position', axesPositionA);
    yyaxis(axisTempA2, 'right');
    ylabel(axisTempA2, "DC Voltage, mV");
    yyaxis(axisTempA2, 'left');
    ylabel(axisTempA2, "10^6 X_{2\omega}/DC");

    set(axisTempB2, 'Position', axesPositionB);
    yyaxis(axisTempB2, 'right');
    ylabel(axisTempB2, "Y_{2\omega}, \muV");
    yyaxis(axisTempB2, 'left');
    ylabel(axisTempB2, "X_{2\omega}, \muV");

    set(axisTempC2, 'Position', axesPositionC);
    yyaxis(axisTempC2, 'right');
    ylabel(axisTempC2, "Q, deg");
    yyaxis(axisTempC2, 'left');
    ylabel(axisTempC2, "R_{2\omega}/DC, \muV");

    graphics = struct('figure', f, 'axes', a);

end