function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax_time_A, ax_time_B, ax_volt_A, ax_volt_B] = util.unpack(graphics.axes);
    for ax = [ax_time_A, ax_time_B, ax_volt_A, ax_volt_B]
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    % Transport
    t = logdata.watch.datetime;         % Time, datetime
    t = t - t(1);                       % Time, seconds
    t = minutes(t);                     % Time, minutes

    
    Vg = logdata.source.V;               % Gate voltage, V
    Ig = 1e9*logdata.source.I;           % Gate leakadge current, nA

    coil_const = 25;                  % Coil constant, mT/A
    MagnetCurrent = logdata.magnet.I;   % Magnet current, A
    MagnetVoltage = logdata.magnet.V;   % Magnet voltage, V
    Field = coil_const*MagnetCurrent;   % Magnetic field, mT

    tempA = logdata.tempcont.A;         % Temperature, K
    tempB = logdata.tempcont.B;         % Temperature, K
    % Vout = logdata.lockinA.amplitude;   % Output Amplitude, V
    Ixx = 1e9*logdata.lockinA.X;        % Current, nA
    % IxxY = 1e9*logdata.lockinA.Y;       % Current, nA
    VxxX = 1e6*logdata.lockinB.X;       % X channel, uV
    % VxxY = 1e6*logdata.lockinB.Y;       % Y channel, uV
    Ryx = VxxX./Ixx;                    % Resistance XX, kOhm

    [Field, Ixx, Ryx] = ...
        util.coarse.sweep(logdata.sweep, Field, Ixx, Ryx);

    % Time domain
    yyaxis(ax_time_A, 'left');
    plot(ax_time_A, t, MagnetCurrent, 'r.-');
    yyaxis(ax_time_A, 'right');
    plot(ax_time_A, t, Vg, 'b.-');

    yyaxis(ax_time_B, 'left');
    plot(ax_time_B, t, tempA, 'r.-');
    yyaxis(ax_time_B, 'right');
    plot(ax_time_B, t, tempB, 'b.-');

    % Gate voltage domain
    yyaxis(ax_volt_A, 'left');
    plot(ax_volt_A, Field, Ryx, 'r-');
    yyaxis(ax_volt_B, 'left');
    plot(ax_volt_B, Field, Ixx, 'r-');

end