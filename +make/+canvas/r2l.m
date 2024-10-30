function graphics = r2l()
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
    tabTime = uitab(tabgroup, 'Title', 'Res vs Time');
    tabTemp = uitab(tabgroup, 'Title', 'Temp vs Time');
    tabTempA = uitab(tabgroup, 'Title', 'Res vs Temp A');

    axisTimeA = axes(tabTime);
    hold(axisTimeA, 'on');
    grid(axisTimeA, 'on');
    title(axisTimeA, 'Lockin A');
    set(axisTimeA, 'Units', 'centimeters');
    set(axisTimeA, 'Position', axesPositionA);
    set(axisTimeA, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTimeA, 'right');
    set(axisTimeA, 'YColor', 'b');
    ylabel(axisTimeA, "Resistance Y, k\Omega");
    yyaxis(axisTimeA, 'left');
    set(axisTimeA, 'YColor', 'r');
    ylabel(axisTimeA, "Resistance X, k\Omega");

    axisTimeB = axes(tabTime);
    hold(axisTimeB, 'on');
    grid(axisTimeB, 'on');
    title(axisTimeB, 'Lockin B');
    set(axisTimeB, 'Units', 'centimeters');
    set(axisTimeB, 'Position', axesPositionB);
    set(axisTimeB, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
    set(axisTimeB, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTimeB, 'right');
    set(axisTimeB, 'YColor', 'b');
    ylabel(axisTimeB, "Resistance Y, k\Omega");
    yyaxis(axisTimeB, 'left');
    set(axisTimeB, 'YColor', 'r');
    ylabel(axisTimeB, "Resistance X, k\Omega");

    axisTimeC = axes(tabTime);
    hold(axisTimeC, 'on');
    grid(axisTimeC, 'on');
    title(axisTimeC, 'Source');
    set(axisTimeC, 'Units', 'centimeters');
    set(axisTimeC, 'Position', axesPositionC);
    set(axisTimeC, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
    set(axisTimeC, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTimeC, 'right');
    set(axisTimeC, 'YColor', 'b');
    ylabel(axisTimeC, "");
    yyaxis(axisTimeC, 'left');
    set(axisTimeC, 'YColor', 'r');
    ylabel(axisTimeC, "");
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
    title(axisTempA, 'Lockin A');
    set(axisTempA, 'Units', 'centimeters');
    set(axisTempA, 'Position', axesPositionA);
    set(axisTempA, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTempA, 'right');
    set(axisTempA, 'YColor', 'b');
    ylabel(axisTempA, "Resistance Y, k\Omega");
    yyaxis(axisTempA, 'left');
    set(axisTempA, 'YColor', 'r');
    ylabel(axisTempA, "Resistance X, k\Omega");

    axisTempB = axes(tabTempA);
    hold(axisTempB, 'on');
    grid(axisTempB, 'on');
    title(axisTempB, 'Lockin B');
    set(axisTempB, 'Units', 'centimeters');
    set(axisTempB, 'Position', axesPositionB);
    set(axisTempB, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
    set(axisTempB, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTempB, 'right');
    set(axisTempB, 'YColor', 'b');
    ylabel(axisTempB, "Resistance Y, k\Omega");
    yyaxis(axisTempB, 'left');
    set(axisTempB, 'YColor', 'r');
    ylabel(axisTempB, "Resistance X, k\Omega");

    axisTempC = axes(tabTempA);
    hold(axisTempC, 'on');
    grid(axisTempC, 'on');
    title(axisTempC, 'Source');
    set(axisTempC, 'Units', 'centimeters');
    set(axisTempC, 'Position', axesPositionC);
    set(axisTempC, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
    set(axisTempC, 'FontSize', 12, 'FontName', 'Arial');
    yyaxis(axisTempC, 'right');
    set(axisTempC, 'YColor', 'b');
    ylabel(axisTempC, "");
    yyaxis(axisTempC, 'left');
    set(axisTempC, 'YColor', 'r');
    ylabel(axisTempC, "");
    xlabel(axisTempC, "Temp, K");

    a = [axisTimeA, axisTimeB, axisTimeC, ...
            axisTempa, axisTempb, ...
            axisTempA, axisTempB, axisTempC];

    graphics = struct('figure', f, 'axes', a);

end