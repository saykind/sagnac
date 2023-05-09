function graphics = make_graphics(key)
%Initialization function.
%   numeric key creates pre-defined experiment setups:
%       104 'h' -   Hall transport (SR830, SR830, LSCI331, KEPCO)
%        84 'T' -   temperature (LSCI331)


f = figure('Name', Sweeper.make_title(key), 'Units', 'centimeters');

switch key
    case {84, 'T'} % Temperature
        set(f,  'Position',  [0, 0, 25, 8]);
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
        
        axisB = axes(t ,'FontSize', 12, 'FontName', 'Arial', ...
            'XGrid', 'on', 'YGrid', 'on', 'Box', 'off', 'Color', 'none', ...
            'XAxisLocation', 'top', 'YAxisLocation', 'right', ...
            'YColor', 'b');
        ylabel(axisB, "Temp B, K");
        
        hold(axisA, 'on'); 
        hold(axisB, 'on');
        
        a = [axisA, axisB];
        
    case {104, 'h'} % Hall effect
        set(f,  'Position',  [0, 0, 24, 15]);
        sizeLeft = 3;
        sizeBottomA = 8;
        sizeBottomB = 2;
        sizeWidth = 18;
        sizeLength = 5;
        axesPositionA = [sizeLeft, sizeBottomA, sizeWidth, sizeLength];
        axesPositionB = [sizeLeft, sizeBottomB, sizeWidth, sizeLength];
        
        tabgroup = uitabgroup(f);
        tabHall = uitab(tabgroup, 'Title', 'Hall Effect');
        tabTemp = uitab(tabgroup, 'Title', 'Transport vs Temp');
        tabTime = uitab(tabgroup, 'Title', 'Transport vs Time');
        tabMisc = uitab(tabgroup, 'Title', 'Misc vs Time');
        
        axisHallA = axes(tabHall);
        hold(axisHallA, 'on');
        grid(axisHallA, 'on');
        title(axisHallA, 'Hall Effect');
        set(axisHallA, 'Units', 'centimeters');
        set(axisHallA, 'Position', axesPositionA);
        set(axisHallA, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisHallA, 'right');
        set(axisHallA, 'YColor', 'b');
        ylabel(axisHallA, "Voltage_A Y, mV");
        yyaxis(axisHallA, 'left');
        set(axisHallA, 'YColor', 'r');
        ylabel(axisHallA, "Voltage_A X, mV");
        
        axisHallB = axes(tabHall);
        hold(axisHallB, 'on');
        grid(axisHallB, 'on');
        set(axisHallB, 'Units', 'centimeters');
        set(axisHallB, 'Position', axesPositionB);
        set(axisHallB, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
        set(axisHallB, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisHallB, 'right');
        set(axisHallB, 'YColor', 'b');
        ylabel(axisHallB, "Voltage_B Y, mV");
        yyaxis(axisHallB, 'left');
        set(axisHallB, 'YColor', 'r');
        ylabel(axisHallB, "Voltage_B X, mV");
        xlabel(axisHallB, "Magnet Current, mA");

        axisTimeA = axes(tabTime);
        hold(axisTimeA, 'on');
        grid(axisTimeA, 'on');
        title(axisTimeA, 'Time domain');
        set(axisTimeA, 'Units', 'centimeters');
        set(axisTimeA, 'Position', axesPositionA);
        set(axisTimeA, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisTimeA, 'right');
        set(axisTimeA, 'YColor', 'b');
        ylabel(axisTimeA, "Voltage_A Y, mV");
        yyaxis(axisTimeA, 'left');
        set(axisTimeA, 'YColor', 'r');
        ylabel(axisTimeA, "Voltage_A X, mV");
        
        axisTimeB = axes(tabTime);
        hold(axisTimeB, 'on');
        grid(axisTimeB, 'on');
        set(axisTimeB, 'Units', 'centimeters');
        set(axisTimeB, 'Position', axesPositionB);
        set(axisTimeB, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
        set(axisTimeB, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisTimeB, 'right');
        set(axisTimeB, 'YColor', 'b');
        ylabel(axisTimeB, "Voltage_B Y, mV");
        yyaxis(axisTimeB, 'left');
        set(axisTimeB, 'YColor', 'r');
        ylabel(axisTimeB, "Voltage_B X, mV");
        xlabel(axisTimeB, "Time, min");
        
        axisTempA = axes(tabTemp);
        hold(axisTempA, 'on');
        grid(axisTempA, 'on');
        title(axisTempA, 'Temperature domain');
        set(axisTempA, 'Units', 'centimeters');
        set(axisTempA, 'Position', axesPositionA);
        set(axisTempA, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisTempA, 'right');
        set(axisTempA, 'YColor', 'b');
        ylabel(axisTempA, "Voltage_A Y, mV");
        yyaxis(axisTempA, 'left');
        set(axisTempA, 'YColor', 'r');
        ylabel(axisTempA, "Voltage_A X, mV");
        
        axisTempB = axes(tabTemp);
        hold(axisTempB, 'on');
        grid(axisTempB, 'on');
        set(axisTempB, 'Units', 'centimeters');
        set(axisTempB, 'Position', axesPositionB);
        set(axisTempB, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
        set(axisTempB, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisTempB, 'right');
        set(axisTempB, 'YColor', 'b');
        ylabel(axisTempB, "Voltage_B Y, mV");
        yyaxis(axisTempB, 'left');
        set(axisTempB, 'YColor', 'r');
        ylabel(axisTempB, "Voltage_B X, mV");
        xlabel(axisTempB, "Temperature, K");
        
        axisMiscA = axes(tabMisc);
        hold(axisMiscA, 'on');
        grid(axisMiscA, 'on');
        title(axisMiscA, 'Time domain');
        set(axisMiscA, 'Units', 'centimeters');
        set(axisMiscA, 'Position', axesPositionA);
        set(axisMiscA, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisMiscA, 'right');
        set(axisMiscA, 'YColor', 'b');
        ylabel(axisMiscA, "Temp B, K");
        yyaxis(axisMiscA, 'left');
        set(axisMiscA, 'YColor', 'r');
        ylabel(axisMiscA, "Temp A, K");
        
        axisMiscB = axes(tabMisc);
        hold(axisMiscB, 'on');
        grid(axisMiscB, 'on');
        set(axisMiscB, 'Units', 'centimeters');
        set(axisMiscB, 'Position', axesPositionB);
        set(axisMiscB, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
        set(axisMiscB, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisMiscB, 'right');
        set(axisMiscB, 'YColor', 'b');
        ylabel(axisMiscB, "Magnet V, V");
        yyaxis(axisMiscB, 'left');
        set(axisMiscB, 'YColor', 'r');
        ylabel(axisMiscB, "Magnet I, mA");
        xlabel(axisMiscB, "Time, min");
        
        a = [axisHallA, axisHallB, ...
            axisTimeA, axisTimeB, ...
            axisTempA, axisTempB, ...
            axisMiscA, axisMiscB];
    otherwise
        disp("Unknown seed.")
end

for i = 1:numel(a), disableDefaultInteractivity(a(i)); end

graphics = struct();
graphics.figure = f;
graphics.axes = a;

