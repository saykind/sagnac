function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax_res_A, ax_res_B, ax_volt_A, ax_volt_B, ax_volt_C] = util.unpack(graphics.axes);
    cla(ax_res_A) 
    cla(ax_res_B)
    for ax = [ax_volt_A, ax_volt_B, ax_volt_C]
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    % Transport
    resistor = 10.4*1e6;                % Resistor, Ohm 
    Vout = logdata.lockinA.amplitude;   % Output Amplitude, V
    Ixx = 1e9*logdata.lockinA.X;        % Current, nA
    IxxY = 1e9*logdata.lockinA.Y;      % Current, nA
    VxxX = 1e6*logdata.lockinB.X;       % X channel, uV
    VxxY = 1e6*logdata.lockinB.Y;       % Y channel, uV
    VyxX = 1e6*logdata.lockinC.X;       % X channel, uV
    VyxY = 1e6*logdata.lockinC.Y;       % Y channel, uV
    Rxx = VxxX./Ixx;                    % Resistance XX, kOhm
    Ryx = VxxY./Ixx;                    % Resistance YX, kOhm

    plot(ax_res_A, Ixx, Rxx, 'k-');
    plot(ax_res_B, Ixx, Ryx, 'r-');

    yyaxis(ax_volt_A, 'left');
    plot(ax_volt_A, Vout, Ixx, 'r-');
    yyaxis(ax_volt_A, 'right');
    plot(ax_volt_A, Vout, atan2d(IxxY, Ixx), 'b--');

    yyaxis(ax_volt_B, 'left');
    plot(ax_volt_B, Vout, VxxX, 'r-');
    yyaxis(ax_volt_B, 'right');
    plot(ax_volt_B, Vout, VxxY, 'b-');

    yyaxis(ax_volt_C, 'left');
    plot(ax_volt_C, Vout, VyxX, 'r-');
    yyaxis(ax_volt_C, 'right');
    plot(ax_volt_C, Vout, VyxY, 'b-');

end