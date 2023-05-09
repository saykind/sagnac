function graphics = graphics(key, graphics, logdata)
%Graphics initialization and plotting function.
%   Numeric key selects pre-defined experiment setups.

if nargin < 1, error("[make.graphics] Please provide key."); end

%% Create graphics
if nargin == 1
    f = figure('Name', make.title(key), 'Units', 'centimeters');
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

            xtickformat(axisA, '%.1f');
            %xtickformat(axisB, 'hh:mm:ss');

            a = [axisA, axisB];

        case {112, 'p'} % Optical power
            set(f,  'Position',  [0, 0, 25, 8]);
            t = tiledlayout(f,1,1);

            axis = axes(t, ...
                'FontSize', 12, ...
                'FontName', 'Arial', ...
                'XGrid', 'on', ...
                'YGrid', 'on', ...
                'Box', 'off', ...
                'YColor', 'r');
            xlabel(axis, "Current, mA");
            yyaxis(axis, 'right');
            set(axis, 'YColor', 'b');
            ylabel(axis, "Voltage, V");
            ylim(axis, [0,inf]);
            yyaxis(axis, 'left');
            set(axis, 'YColor', 'r');
            ylabel(axis, "Power, mW");

            hold(axis, 'on'); 
            xtickformat(axis, '%.1f');

            a = axis;

        case {100, 'd'} % Optical power
            set(f,  'Position',  [0, 0, 25, 8]);
            t = tiledlayout(f,1,1);

            axis = axes(t, ...
                'FontSize', 12, ...
                'FontName', 'Arial', ...
                'XGrid', 'on', ...
                'YGrid', 'on', ...
                'Box', 'off', ...
                'YColor', 'r');
            xlabel(axis, "Current, mA");
            yyaxis(axis, 'right');
            set(axis, 'YColor', 'b');
            ylabel(axis, "Voltage, V");
            ylim(axis, [0,inf]);
            yyaxis(axis, 'left');
            set(axis, 'YColor', 'r');
            ylabel(axis, "DC Voltage, mV");

            hold(axis, 'on'); 
            xtickformat(axis, '%.1f');

            a = axis;

        case {119, 'w'} % Wavelength
            set(f,  'Position',  [0, 0, 25, 8]);
            t = tiledlayout(f,1,1);

            axis = axes(t, ...
                'FontSize', 12, ...
                'FontName', 'Arial', ...
                'XGrid', 'on', ...
                'YGrid', 'on', ...
                'Box', 'off', ...
                'YColor', 'r');
            xlabel(axis, "Wavelength, nm");
            ylabel(axis, "Optical Power, mW");

            hold(axis, 'on');

            a = axis;

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
            tabTemp = uitab(tabgroup, 'Title', 'Transport vs Temp');
            tabTime = uitab(tabgroup, 'Title', 'Transport vs Time');
            tabMisc = uitab(tabgroup, 'Title', 'Misc vs Time');

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

            a = [axisTimeA, axisTimeB, ...
                axisTempA, axisTempB, ...
                axisMiscA, axisMiscB];
        otherwise
            disp("Unknown seed.")
    end
    
    %FIXME This should not be here when called to plot from datafile
    for i = 1:numel(a), disableDefaultInteractivity(a(i)); end

    graphics = struct();
    graphics.figure = f;
    graphics.axes = a;
    
    return
end

%% Given graphics draw a plot    
    switch key
        case {84, 'T'}
            axisA = graphics.axes(1);
            axisB = graphics.axes(2);
            cla(axisA); cla(axisB);

            t = logdata.timer.time/60;
            d = datetime(logdata.timer.datetime);
            %t = (1:numel(logdata.timer.time(:,1)));
            %t = t/60;
            %d = datetime(logdata.timer.time);
            TA = logdata.tempcont.A;
            TB = logdata.tempcont.B;

            plot(axisA, t, TA, 'Color', 'r');
            plot(axisB, d, TB, 'Color', 'b');

            set(axisA, 'XLim', [min(t), max(t)], ...
                'XTick', linspace(min(t), max(t), 7));
            set(axisB, 'XLim', [min(d), max(d)], ...
                'XTick', linspace(min(d), max(d), 7));

        case {112, 'p'}
            axis = graphics.axes;
            cla(axis);

            i = logdata.diode.current;
            p = logdata.powermeter.power;
            v = logdata.diode.voltage;

            yyaxis(axis, 'left');
            plot(axis, i, 1e3*p, '.-r');
            yyaxis(axis, 'right');
            plot(axis, i, v, '-b');

        case {100, 'd'}
            axis = graphics.axes;
            cla(axis);

            i = logdata.diode.current;
            dc = logdata.voltmeter.v1;
            v = logdata.diode.voltage;
            
            yyaxis(axis, 'left');
            plot(axis, i, 1e3*dc, '.r');
            yyaxis(axis, 'right');
            plot(axis, i, v, '-b');

        case {119, 'w'}
            axis = graphics.axes;
            cla(axis);

            w = logdata.powermeter.wavelength;
            p = logdata.powermeter.power;

            plot(axis, w, 1e3*p, '.r');

        case {104, 'h'}
            axisHallTimeA = graphics.axes(1);
            axisHallTimeB = graphics.axes(2);
            axisHallTempA = graphics.axes(3);
            axisHallTempB = graphics.axes(4);
            axisTempTime = graphics.axes(5);
            axisMagnTime = graphics.axes(6);
            cla(axisHallTimeA); yyaxis(axisHallTimeA, 'left'); cla(axisHallTimeA);
            cla(axisHallTimeB); yyaxis(axisHallTimeB, 'left'); cla(axisHallTimeB);
            cla(axisHallTempA); yyaxis(axisHallTempA, 'left'); cla(axisHallTempA);
            cla(axisHallTempB); yyaxis(axisHallTempB, 'left'); cla(axisHallTempB);
            cla(axisTempTime);  yyaxis(axisTempTime,  'left'); cla(axisTempTime);
            cla(axisMagnTime);  yyaxis(axisMagnTime,  'left'); cla(axisMagnTime);

            t = logdata.timer.time/60;      % Time, min
            TA = logdata.tempcont.A;        % Sample temperature, K
            TB = logdata.tempcont.B;        % Magnet temperature, K
            VAX = 1e3*logdata.lockinA.X;    % Lockin-A Voltage X, mV
            VAY = 1e3*logdata.lockinA.Y;    % Lockin-A Voltage Y, mV
            VBX = 1e3*logdata.lockinB.X;    % Lockin-B Voltage X, mV
            VBY = 1e3*logdata.lockinB.Y;    % Lockin-B Voltage Y, mV
            MagI = 1e3*logdata.magnet.I;    % Magnet Current, mA
            MagV = logdata.magnet.V;        % Magnet Voltage, V

            yyaxis(axisHallTimeA, 'left');
            plot(axisHallTimeA, t, VAX, 'Color', 'r');
            yyaxis(axisHallTimeA, 'right');
            plot(axisHallTimeA, t, VAY, 'Color', 'b');

            yyaxis(axisHallTimeB, 'left');
            plot(axisHallTimeB, t, VBX, 'Color', 'r');
            yyaxis(axisHallTimeB, 'right');
            plot(axisHallTimeB, t, VBY, 'Color', 'b');

            yyaxis(axisHallTempA, 'left');
            plot(axisHallTempA, TA, VAX, 'Color', 'r');
            yyaxis(axisHallTempA, 'right');
            plot(axisHallTempA, TA, VAY, 'Color', 'b');

            yyaxis(axisHallTempB, 'left');
            plot(axisHallTempB, TA, VBX, 'Color', 'r');
            yyaxis(axisHallTempA, 'right');
            plot(axisHallTempB, TA, VBY, 'Color', 'b');

            yyaxis(axisTempTime, 'left');
            plot(axisTempTime, t, TA, 'Color', 'r');
            yyaxis(axisTempTime, 'right');
            plot(axisTempTime, t, TB, 'Color', 'b');

            yyaxis(axisMagnTime, 'left');
            plot(axisMagnTime, t, MagI, 'Color', 'r');
            yyaxis(axisMagnTime, 'right');
            plot(axisMagnTime, t, MagV, 'Color', 'b');

        otherwise
            disp("Unknown seed.")
    end
