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

    % Lockin data
    dc = 1e3*logdata.lockin.auxin0(:,1);
    % [x1, y1, x2, y2, r1, r2, kerr] = util.logdata.lockin(logdata.lockin);
    
    Vg = logdata.lockinA.AUXV1;         % Gate voltage, V

    tempA = logdata.tempcont.A;         % Temperature, K
    tempB = logdata.tempcont.B;         % Temperature, K
    % Vout = logdata.lockinA.amplitude;   % Output Amplitude, V
    IxxX = 1e12*logdata.lockinA.X;      % Current, pA
    IxxY = 1e12*logdata.lockinA.Y;      % Current, pA
    VxxX = 1e6*logdata.lockinB.X;       % X channel, uV
    VxxY = 1e6*logdata.lockinB.Y;       % Y channel, uV
    % Rxx = VxxX./IxxX;                    % Resistance XX, kOhm

    angle = logdata.waveplate.angle;

    [IxxX, IxxY, VxxX, VxxY, Angle] = ...
        util.coarse.sweep(logdata.sweep, IxxX, IxxY, VxxX, VxxY, angle);

    % Time domain
    yyaxis(ax_time_A, 'left');
    plot(ax_time_A, angle, Vg, 'r.-');
    yyaxis(ax_time_A, 'right');
    plot(ax_time_A, angle, dc, 'b.-');

    yyaxis(ax_time_B, 'left');
    plot(ax_time_B, t, tempA, 'r.-');
    yyaxis(ax_time_B, 'right');
    plot(ax_time_B, t, tempB, 'b.-');

    % Gate voltage domain
    yyaxis(ax_volt_A, 'left');
    plot(ax_volt_A, Angle, IxxX, 'r-');
    yyaxis(ax_volt_A, 'right');
    plot(ax_volt_A, Angle, IxxY, 'b-');

    yyaxis(ax_volt_B, 'left');
    plot(ax_volt_B, Angle, VxxX, 'r-');
    yyaxis(ax_volt_B, 'right');
    plot(ax_volt_B, Angle, VxxY, 'b-');

end