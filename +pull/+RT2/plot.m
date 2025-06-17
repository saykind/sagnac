function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax_res_A, ax_res_B, ax_volt_A, ax_volt_B] = util.unpack(graphics.axes);
    cla(ax_res_A) 
    cla(ax_res_B)
    for ax = [ax_volt_A, ax_volt_B]
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    % Transport
    t = logdata.watch.datetime;         % Time, datetime
    t = t - t(1);                       % Time, seconds
    t = minutes(t);                     % Time, minutes

    tempA = logdata.tempcont.A;         % Temperature, K
    tempB = logdata.tempcont.B;         % Temperature, K
    Vout = logdata.lockinA.amplitude;   % Output Amplitude, V

    Ixx = 1e9*logdata.lockinA.X;        % Current, nA
    IxxY = 1e9*logdata.lockinA.Y;       % Current, nA
    VxxX = 1e6*logdata.lockinB.X;       % X channel, uV
    VxxY = 1e6*logdata.lockinB.Y;       % Y channel, uV
    Rxx = 1e3*VxxX./Ixx;                    % Resistance XX, Ohm

    yyaxis(ax_res_A, 'left');
    plot(ax_res_A, tempB, Rxx, 'r.-');  % FIXME
    yyaxis(ax_res_A, 'right');
    plot(ax_res_A, tempB, atan2d(VxxY, VxxX), 'b-');    % FIXME 

    yyaxis(ax_res_B, 'left');
    plot(ax_res_B, t, tempA, 'r-');
    yyaxis(ax_res_B, 'right');
    plot(ax_res_B, t, tempB, 'b-');

    yyaxis(ax_volt_A, 'left');
    plot(ax_volt_A, tempA, Ixx, 'r-');
    yyaxis(ax_volt_A, 'right');
    plot(ax_volt_A, tempA, atan2d(IxxY, Ixx), 'b--');

    yyaxis(ax_volt_B, 'left');
    plot(ax_volt_B, tempA, VxxX, 'r-');
    yyaxis(ax_volt_B, 'right');
    plot(ax_volt_B, tempA, VxxY, 'b-');

end