function graphics = graphics_init(key)
%Graphics initialization and plotting function.
%   Seed selects pre-defined experiment setups.
%
%   See also:
%       make.graphics();


%% Header
if nargin < 1, error("[make.graphics_init] Please provide seed/key."); end

f = figure('Units', 'centimeters');

switch key
    case 12412 %tk: time vs Kerr
        set(f,  'Position',  [0, 0, 24, 15]);
        tl = tiledlayout(f,3,1);
        axisA = nexttile(tl);
        axisB = nexttile(tl);
        axisC = nexttile(tl);
        a = [axisA, axisB, axisC];
        ylabels = [...
            "Kerr signal, \murad",      "DC, mV"; ...
            "1\omega X, \muV",  "1\omega Y, \muV"; ...
            "2\omega X, mV",  "2\omega Y, mV"; ...
            ];
        title(axisA, 'Time domain');
        xlabel(axisC, "Time, min");
        for i = 1:length(a)
            axis = a(i);
            hold(axis, 'on'); grid(axis, 'on');
            set(axis, 'Units', 'centimeters');
            set(axis, 'FontSize', 12, 'FontName', 'Arial');
            yyaxis(axis, 'right'); set(axis, 'YColor', 'b');
            ylabel(axis, ylabels(i,2));
            yyaxis(axis, 'left'); set(axis, 'YColor', 'r');
            ylabel(axis, ylabels(i,1));
        end

    case 11600 %td: dc voltage (time only)
        set(f,  'Position',  [0, 0, 24, 22]);
        tl = tiledlayout(f,3,1);
        axisA = nexttile(tl);
        axisB = nexttile(tl);
        axisC = nexttile(tl);
        a = [axisA, axisB, axisC];
        ylabels = [...
            "V_0, mV",      "P_0, \muW"; ...
            "V_{2\omega} X, mV",  "V_{2\omega} Y, mV"; ...
            "P_{2\omega}, \muW",  "P_{2\omega}/P_0"; ...
            ];
        title(axisA, 'Reflectivity');
        xlabel(axisC, "Time, min");
        for i = 1:length(a)
            axis = a(i);
            hold(axis, 'on'); grid(axis, 'on');
            set(axis, 'Units', 'centimeters');
            set(axis, 'FontSize', 12, 'FontName', 'Arial');
            yyaxis(axis, 'right'); set(axis, 'YColor', 'b');
            ylabel(axis, ylabels(i,2));
            yyaxis(axis, 'left'); set(axis, 'YColor', 'r');
            ylabel(axis, ylabels(i,1));
        end
        
    case 9900 %dc: dc voltage (LARGGE text)
        set(f,  'Position',  [0, 0, 40, 22]);
        tl = tiledlayout(f,1,1);
        ax = nexttile(tl);
        
        title(ax, 'Reflectivity');
        set(ax, 'Units', 'centimeters');
        set(ax, 'FontSize', 20, 'FontName', 'Arial');
        set(ax, 'visible', 'off');
       
        text(ax, .0, .65, "DC = 00.00 mV.", 'FontSize', 120);
        text(ax, .0, .35, "MAX = 00.00 mV.", 'FontSize', 120);

        a = ax;


    case 84     %T: Temperature
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
        xtickformat(axisA, '%.0f');
        %xtickformat(axisB, 'hh:mm:ss');
        a = [axisA, axisB];

    case 107    %k: Kerr (main)
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
         
         
case 1290848    %kth: Kerr, transport, hall
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
        tabTempA = uitab(tabgroup, 'Title', 'Kerr vs Temp A');
        tabTempB = uitab(tabgroup, 'Title', 'Kerr vs Temp B');
        tabPower = uitab(tabgroup, 'Title', 'Kerr vs Power');
        tabHall = uitab(tabgroup, 'Title', 'Hall vs Temp A');
        tabTrans = uitab(tabgroup, 'Title', 'Transport vs Temp A');

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
        set(axisTempBa, 'Position', axesPosition0);
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
        
        axisHall = axes(tabHall);
        hold(axisHall, 'on');
        grid(axisHall, 'on');
        title(axisHall, 'Hall sesnor');
        set(axisHall, 'Units', 'centimeters');
        set(axisHall, 'Position', axesPosition0);
        set(axisHall, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisHall, 'right');
        set(axisHall, 'YColor', 'b');
        yyaxis(axisHall, 'left');
        set(axisHall, 'YColor', 'r');
        ylabel(axisHall, "Mag field H, Oe");
        xlabel(axisHall, "Temp, K");
        
        axisTr = axes(tabTrans);
        hold(axisTr, 'on');
        grid(axisTr, 'on');
        title(axisTr, 'Hall sesnor');
        set(axisTr, 'Units', 'centimeters');
        set(axisTr, 'Position', axesPosition0);
        set(axisTr, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisTr, 'right');
        set(axisTr, 'YColor', 'b');
        yyaxis(axisTr, 'left');
        set(axisTr, 'YColor', 'r');
        ylabel(axisTr, "Resistance, Ohm");
        xlabel(axisTr, "Temp, K");

        a = [axisTimeA, axisTimeB, axisTimeC, ...
             axisTempa, axisTempb, ...
             axisTempA, axisTempB, axisTempC, ...
             axisTempBa, ...
             axisPowera, axisPowerb, ...
             axisHall, ...
             axisTr];


    case 102 %f: Mod freq sweep
        set(f,  'Position',  [0, 0, 24, 24]);
        tl = tiledlayout(f, 2, 1);

        axisA = nexttile(tl);
        axisB = nexttile(tl);

        a = [axisA, axisB];
        ylabels = [...
            "Ratio P_{AC}/P_0",     "DC Power, \muW"; ...
            "Mag P_{AC}, \muW",    "Ph \theta_{AC}, deg"
            ];

        title(axisA, 'Modulation frequency sweep');
        xlabel(axisA, "Frequency, MHz");

        for i = 1:length(a)
            axis = a(i);
            hold(axis, 'on');
            grid(axis, 'on');
            set(axis, 'Units', 'centimeters');
            set(axis, 'FontSize', 12, 'FontName', 'Arial');
            yyaxis(axis, 'right'); set(axis, 'YColor', 'b');
            ylabel(axis, ylabels(i,2));
            yyaxis(axis, 'left'); set(axis, 'YColor', 'r');
            ylabel(axis, ylabels(i,1));
        end

    case 97 %a: Mod freq sweep
        set(f,  'Position',  [0, 0, 24, 24]);
        tl = tiledlayout(f, 2, 1);

        axisA = nexttile(tl);
        axisB = nexttile(tl);

        a = [axisA, axisB];
        ylabels = [...
            "Ratio P_{AC}/P_0",      "DC Power, \muW"; ...
            "Mag P_{AC}, \muW",    "Ph \theta_{AC}, deg"
            ];

        title(axisA, 'Modulation amplitude sweep');
        xlabel(axisA, "Amplitude Vpp, V");

        for i = 1:length(a)
            axis = a(i);
            hold(axis, 'on');
            grid(axis, 'on');
            set(axis, 'Units', 'centimeters');
            set(axis, 'FontSize', 12, 'FontName', 'Arial');
            yyaxis(axis, 'right'); set(axis, 'YColor', 'b');
            ylabel(axis, ylabels(i,2));
            yyaxis(axis, 'left'); set(axis, 'YColor', 'r');
            ylabel(axis, ylabels(i,1));
        end
        
    
    case 9894 %fa: Mod freq and ampl sweep
        set(f,  'Position',  [0, 0, 24, 24]);
        tl = tiledlayout(f, 2, 1);

        axisA = nexttile(tl);
        axisB = nexttile(tl);

        a = [axisA, axisB];
        xylabels = [...
            "Frequency, MHz",      "Amplitude, Vpp"; ...
            ];

        title(axisA, 'DC power P_0, \muW');
        title(axisB, 'AC power P_{AC}, \muW');
        %title(axisB, '1\omega Power Ratio, P_1/P_0');
        
        colorbar(axisA);
        colorbar(axisB);

        for i = 1:length(a)
            axis = a(i);
            hold(axis, 'on');
            grid(axis, 'on');
            set(axis, 'Units', 'centimeters');
            set(axis, 'FontSize', 12, 'FontName', 'Arial');
            xlabel(axis, xylabels(1));
            ylabel(axis, xylabels(2));
        end
        
    
    case 120 %x: Kerr 1D scan
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
        xlabel(axis, "Position, mm");
        ylabel(axis, "Kerr \theta, \murad");
        yyaxis(axis, 'right');
        ylabel(axis, "DC power, \muW");
    
        
    case 14520 %xy: Kerr 2D scan
        set(f,  'Position',  [0, 0, 36, 18]);
        tl = tiledlayout(f, 1, 2);

        axisA = nexttile(tl);
        axisB = nexttile(tl);

        a = [axisA, axisB];
        axesTitles = ["DC power P_0, \muW", "Kerr signal \theta, \murad"];
        quantities = ["P_0, \muW", "\theta, \murad"];
        xylabels = ["X, \mum",      "Y, \mum";];

        for i = 1:length(a)
            ax = a(i);
            hold(ax, 'on');
            grid(ax, 'on');
            set(ax, 'Units', 'centimeters');
            set(ax, 'FontSize', 12, 'FontName', 'Arial');
            set(ax, 'DataAspectRatio', [1 1 1]);
            xlabel(ax, xylabels(1));
            ylabel(ax, xylabels(2));
            title(ax, axesTitles(i));
            cb = colorbar(ax);
            cb.Label.String = quantities(i);
            cb.Label.Rotation = 270;
            cb.Label.FontSize = 12;
            cb.Label.VerticalAlignment = "bottom";
        end
        colormap(axisA, parula);
        colormap(axisB, summer);
        


    case 105    %i: Laser intensity sweep
        set(f,  'Position',  [0, 0, 24, 15]);
        tl = tiledlayout(f,3,1);

        axisA = nexttile(tl);
        hold(axisA, 'on');
        grid(axisA, 'on');
        title(axisA, 'Laser intensity sweep');
        set(axisA, 'Units', 'centimeters');
        set(axisA, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisA, 'right');
        set(axisA, 'YColor', 'b');
        ylabel(axisA, "DC Voltage, mV");
        yyaxis(axisA, 'left');
        set(axisA, 'YColor', 'r');
        ylabel(axisA, "Kerr, \murad");

        axisB = nexttile(tl);
        hold(axisB, 'on');
        grid(axisB, 'on');
        set(axisB, 'Units', 'centimeters');
        set(axisB, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
        set(axisB, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisB, 'right');
        set(axisB, 'YColor', 'b');
        ylabel(axisB, "1\omega Voltage Y, \muV");
        yyaxis(axisB, 'left');
        set(axisB, 'YColor', 'r');
        ylabel(axisB, "1\omega Voltage X, \muV");

        axisC = nexttile(tl);
        hold(axisC, 'on');
        grid(axisC, 'on');
        set(axisC, 'Units', 'centimeters');
        set(axisC, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
        set(axisC, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisC, 'right');
        set(axisC, 'YColor', 'b');
        ylabel(axisC, "2\omega Voltage V_{2Y}, mV");
        yyaxis(axisC, 'left');
        set(axisC, 'YColor', 'r');
        ylabel(axisC, "2\omega Voltage V_{2X}, mV");
        xlabel(axisC, "Laser diode current, mA");

        a = [axisA, axisB, axisC];


    case 121    %y: magnetic field sweep
        set(f,  'Position',  [0, 0, 24, 15]);
        tl = tiledlayout(f,3,1);

        axisA = nexttile(tl);
        hold(axisA, 'on');
        grid(axisA, 'on');
        title(axisA, 'Magnetic field sweep');
        set(axisA, 'Units', 'centimeters');
        set(axisA, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisA, 'right');
        set(axisA, 'YColor', 'b');
        ylabel(axisA, "DC Voltage, mV");
        yyaxis(axisA, 'left');
        set(axisA, 'YColor', 'r');
        ylabel(axisA, "Kerr, \murad");

        axisB = nexttile(tl);
        hold(axisB, 'on');
        grid(axisB, 'on');
        set(axisB, 'Units', 'centimeters');
        set(axisB, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
        set(axisB, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisB, 'right');
        set(axisB, 'YColor', 'b');
        ylabel(axisB, "1\omega Voltage Y, \muV");
        yyaxis(axisB, 'left');
        set(axisB, 'YColor', 'r');
        ylabel(axisB, "1\omega Voltage X, \muV");

        axisC = nexttile(tl);
        hold(axisC, 'on');
        grid(axisC, 'on');
        set(axisC, 'Units', 'centimeters');
        set(axisC, 'FontSize', 12, 'FontName', 'Arial', 'YColor', 'r');
        set(axisC, 'FontSize', 12, 'FontName', 'Arial');
        yyaxis(axisC, 'right');
        set(axisC, 'YColor', 'b');
        ylabel(axisC, "2\omega Voltage V_{2Y}, mV");
        yyaxis(axisC, 'left');
        set(axisC, 'YColor', 'r');
        ylabel(axisC, "2\omega Voltage V_{2X}, mV");
        xlabel(axisC, "Magnet current, mA");

        a = [axisA, axisB, axisC];


    case 68     %D: Temperature
        set(f,  'Position',  [0, 0, 25, 8]);
        t = tiledlayout(f,1,1);

        axisA = axes(t, ...
            'FontSize', 12, ...
            'FontName', 'Arial', ...
            'XGrid', 'on', ...
            'YGrid', 'on', ...
            'Box', 'off', ...
            'YColor', 'r');
        xlabel(axisA, "DateTime");
        ylabel(axisA, "Temperature, C");

        hold(axisA, 'on'); 

        xtickformat(axisA, '%.1f');

        a = axisA;

    case 112    %p: Optical power
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

    case 100 %d: dc optical power sweep (Keithley 2182A)
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
        set(axis, 'YColor', 'k');
        ylabel(axis, "DC Power, \muW");
        ylim(axis, [0,inf]);
        yyaxis(axis, 'left');
        set(axis, 'YColor', 'k');
        ylabel(axis, "DC Voltage, mV");

        hold(axis, 'on'); 
        xtickformat(axis, '%.1f');

        a = axis;
        
    case 477128 %LIV:  Laser IV characteristic
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
        
        
    case 11948    %tg: Two transport lockins & gate voltage controller
        set(f,  'Position',  [0, 0, 25, 8]);
        t = tiledlayout(f,1,1);
        
        axis = axes(t, ...
            'FontSize', 12, ...
            'FontName', 'Arial', ...
            'XGrid', 'on', ...
            'YGrid', 'on', ...
            'Box', 'off');
        yyaxis(axis, 'right');
        set(axis, 'YColor', 'b');
        ylabel(axis, "Gate current, nA");
        yyaxis(axis, 'left');
        set(axis, 'YColor', 'r');
        ylabel(axis, "Resistance, kOhm");
        xlabel(axis, "Voltage, V");
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

    case {11960, make.key('hs:')} % Hall sensor
        set(f,  'Position',  [0, 0, 25, 8]);
        t = tiledlayout(f,1,1);
        ax = axes(t, ...
            'FontSize', 12, ...
            'FontName', 'Arial', ...
            'XGrid', 'on', ...
            'YGrid', 'on', ...
            'Box', 'off', ...
            'YColor', 'r');
        xlabel(ax, "Magnet Current, mA");
        ylabel(ax, "Magnetic field, G");
        hold(ax, 'on');
        grid(ax, 'on');
        a = ax;
        
    case 11832  %tf: Transport freq sweep
        set(f,  'Position',  [0, 0, 24, 15]);
        tl = tiledlayout(f,2,1);
        axisA = nexttile(tl);
        axisB = nexttile(tl);
        a = [axisA, axisB];
        ylabels = [...
            "Voltage X, mV",      "Voltage Y, mV"; ...
            "Voltage R, mV",      "Voltage Q, deg"; ...
            ];
        xlabel(axisB, "Frequency, kHz");
        for i = 1:length(a)
            axis = a(i);
            hold(axis, 'on'); grid(axis, 'on');
            set(axis, 'Units', 'centimeters');
            set(axis, 'FontSize', 12, 'FontName', 'Arial');
            yyaxis(axis, 'right'); set(axis, 'YColor', 'b');
            ylabel(axis, ylabels(i,2));
            yyaxis(axis, 'left'); set(axis, 'YColor', 'r');
            ylabel(axis, ylabels(i,1));
        end
        
    otherwise
        disp("Unknown seed.");
        graphics = struct();
        return
end

% Return value
graphics = struct();
graphics.figure = f;
graphics.axes = a;

end