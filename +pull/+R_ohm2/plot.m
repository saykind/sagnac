function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax_res_A, ax_volt_A, ax_volt_B] = util.unpack(graphics.axes);
    cla(ax_res_A)
    for ax = [ax_volt_A, ax_volt_B]
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    % Transport
    resistor = 10.8*1e6;                % Resistor, Ohm 
    Vout = logdata.lockinA.amplitude;   % Output Amplitude, V
    Ixx = 1e9*logdata.lockinA.X;        % Current, nA
    IxxY = 1e9*logdata.lockinA.Y;      % Current, nA
    VxxX = 1e6*logdata.lockinB.X;       % X channel, uV
    VxxY = 1e6*logdata.lockinB.Y;       % Y channel, uV
    Rxx = VxxX./Ixx;                    % Resistance XX, kOhm

    plot(ax_res_A, Ixx, Rxx, 'k-');

    yyaxis(ax_volt_A, 'left');
    plot(ax_volt_A, Vout, Ixx, 'r-');
    yyaxis(ax_volt_A, 'right');
    plot(ax_volt_A, Vout, atan2d(IxxY, Ixx), 'b--');

    yyaxis(ax_volt_B, 'left');
    plot(ax_volt_B, Vout, VxxX, 'r-');
    yyaxis(ax_volt_B, 'right');
    plot(ax_volt_B, Vout, VxxY, 'b-');

end