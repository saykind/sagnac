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
    
    Vg = logdata.lockinA.AUXV1;         % Gate voltage, V

    tempA = logdata.tempcont.A;         % Temperature, K
    tempB = logdata.tempcont.B;         % Temperature, K
    Vout = logdata.lockinA.amplitude;   % Output Amplitude, V
    Ixx = 1e9*logdata.lockinA.X;        % Current, nA
    IxxY = 1e9*logdata.lockinA.Y;       % Current, nA
    VxxX = 1e6*logdata.lockinB.X;       % X channel, uV
    VxxY = 1e6*logdata.lockinB.Y;       % Y channel, uV
    Rxx = VxxX./Ixx;                    % Resistance XX, kOhm

    [Vbg, Ixx, Rxx] = ...
        util.coarse.sweep(logdata.sweep, Vg, Ixx, Rxx);

    % Time domain
    yyaxis(ax_time_A, 'left');
    plot(ax_time_A, t, Vg, 'r-');

    yyaxis(ax_time_B, 'left');
    plot(ax_time_B, t, tempA, 'r-');
    yyaxis(ax_time_B, 'right');
    plot(ax_time_B, t, tempB, 'b-');

    % Gate voltage domain
    yyaxis(ax_volt_A, 'left');
    plot(ax_volt_A, Vbg, Rxx, 'r-');
    % yyaxis(ax_volt_A, 'right');
    % plot(ax_volt_A, Vbg, Ixx, 'b--');

    yyaxis(ax_volt_B, 'left');
    plot(ax_volt_B, Vbg, Ixx, 'r-');
    % yyaxis(ax_volt_B, 'right');
    % plot(ax_volt_B, Vbg, kerr, 'b-');

end