function graphics = make_plot(key, graphics, logdata)
%Elementary data plot function.
%   numeric key creates pre-defined experiment setups:
%       104 'h' -   Hall transport (SR830, SR830, LSCI331, KEPCO)
%        84 'T' -   temperature (LSCI331)

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
        
    case {104, 'h'}
        axisHallA = graphics.axes(1);
        axisHallB = graphics.axes(2);
        axisHallTimeA = graphics.axes(3);
        axisHallTimeB = graphics.axes(4);
        axisHallTempA = graphics.axes(5);
        axisHallTempB = graphics.axes(6);
        axisTempTime = graphics.axes(7);
        axisMagnTime = graphics.axes(8);
        for k = 1:numel(graphics.axes)
            axis = graphics.axes(k);
            yyaxis(axis, 'right'); cla(axis); 
            yyaxis(axis, 'left');  cla(axis);
        end
        
        t = logdata.timer.time/60;      % Time, min
        TA = logdata.tempcont.A;        % Sample temperature, K
        TB = logdata.tempcont.B;        % Magnet temperature, K
        VAX = 1e3*logdata.lockinA.X;    % Lockin-A Voltage X, mV
        VAY = 1e3*logdata.lockinA.Y;    % Lockin-A Voltage Y, mV
        VBX = 1e3*logdata.lockinB.X;    % Lockin-B Voltage X, mV
        VBY = 1e3*logdata.lockinB.Y;    % Lockin-B Voltage Y, mV
        MagI = 1e3*logdata.magnet.I;    % Magnet Current, mA
        MagV = logdata.magnet.V;        % Magnet Voltage, V
        MagI = MagI.*logdata.magnet.polarity;
        MagV = MagV.*logdata.magnet.polarity;
        
        yyaxis(axisHallA, 'left');
        plot(axisHallA, MagI, VAX, '-o', 'Color', 'r');
        yyaxis(axisHallA, 'right');
        plot(axisHallA, MagI, VAY, '-x', 'Color', 'b');
        
        yyaxis(axisHallB, 'left');
        plot(axisHallB, MagI, VBX, '-o', 'Color', 'r');
        yyaxis(axisHallB, 'right');
        plot(axisHallB, MagI, VBY, '-x', 'Color', 'b');
        
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