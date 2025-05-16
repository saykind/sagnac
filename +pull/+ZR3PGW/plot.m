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
    [x1, y1, x2, y2, r1, r2, kerr] = util.logdata.lockin(logdata.lockin);
    
    Vg = logdata.source.V;               % Gate voltage, V
    Ig = 1e9*logdata.source.I;           % Gate leakadge current, nA

    tempA = logdata.tempcont.A;         % Temperature, K
    tempB = logdata.tempcont.B;         % Temperature, K
    Vout = logdata.lockinA.amplitude;   % Output Amplitude, V
    IxxX = 1e12*logdata.lockinA.X;      % Current, pA
    IxxY = 1e12*logdata.lockinA.Y;      % Current, pA
    VxxX = 1e6*logdata.lockinB.X;       % X channel, uV
    VxxY = 1e6*logdata.lockinB.Y;       % Y channel, uV
    VyxX = 1e6*logdata.lockinC.X;       % X channel, uV
    VyxY = 1e6*logdata.lockinC.Y;       % Y channel, uV
    Rxx = VxxX./IxxX;                    % Resistance XX, kOhm
    Ryx = VyxX./IxxX;                    % Resistance YX, kOhm

    angle = logdata.waveplate.angle;

    [Vbg, IxxX, IxxY, VxxX, VxxY, DC, angle] = ...
        util.coarse.sweep(logdata.sweep, Vg, IxxX, IxxY, VxxX, VxxY, dc, angle);

    % Time domain
    yyaxis(ax_time_A, 'left');
    plot(ax_time_A, t, Vg, 'r.-');
    yyaxis(ax_time_A, 'right');
    plot(ax_time_A, t, dc, 'b.-');

    yyaxis(ax_time_B, 'left');
    plot(ax_time_B, t, tempA, 'r.-');
    yyaxis(ax_time_B, 'right');
    plot(ax_time_B, t, tempB, 'b.-');

    % Gate voltage domain
    yyaxis(ax_volt_A, 'left');
    plot(ax_volt_A, angle, IxxX, 'r-');
    yyaxis(ax_volt_A, 'right');
    plot(ax_volt_A, angle, IxxY, 'b-');

    yyaxis(ax_volt_B, 'left');
    plot(ax_volt_B, angle, VxxX, 'r-');
    yyaxis(ax_volt_B, 'right');
    plot(ax_volt_B, angle, VxxY, 'b-');

end