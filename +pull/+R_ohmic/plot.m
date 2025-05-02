function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax_A, ax_B] = util.unpack(graphics.axes);
    for ax = [ax_A, ax_B]
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    % Transport
    resistor = 10.4*1e6;                % Resistor, Ohm 
    ampl = logdata.lockinA.amplitude;   % Output Amplitude, V
    curr = 1e9*ampl/resistor;           % Current, nA
    x = 1e6*logdata.lockinA.X;          % X channel, mV
    y = 1e6*logdata.lockinA.Y;          % Y channel, mV
    res = x./curr;                      % Resistance, kOhm
    phase = atan2d(y,x);                % Phase, deg

    yyaxis(ax_A, 'right');
    plot(ax_A, curr, phase, 'b--');
    yyaxis(ax_A, 'left');
    plot(ax_A, curr, res, 'k-');

    yyaxis(ax_B, 'right');
    plot(ax_B, curr, y, 'b-');
    yyaxis(ax_B, 'left');
    plot(ax_B, curr, x, 'r-');

end