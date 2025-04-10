function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax_temp_A, ax_temp_B, ...
        ax_kerr_dc, ax_kerr_harm, ...
        ax_tran_temp, ax_tran_time] = util.unpack(graphics.axes);
    for ax = [ax_temp_A, ax_temp_B]
        cla(ax);
    end
    for ax = [ax_kerr_dc, ax_kerr_harm, ax_tran_temp, ax_tran_time]
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    time = logdata.watch.datetime-logdata.watch.datetime(1);
    TA = logdata.tempcont.A;
    TB = logdata.tempcont.B;
    dc = 1e3*logdata.lockin.auxin0(:,1);    
    % Compute kerr angle
    [x1, ~, ~, ~, ~, r2, kerr] = util.logdata.lockin(logdata.lockin);
    % Transport
    curr = .1;                          % Current, A (effective)
    res = 1e3*logdata.lockinA.X/curr;   % Resistance, mOhm
    cap = logdata.bridge.C;             % Capacitance, pF
    strain = util.strain.from_capacitance(cap, TA, d0_sample=985);
    %strain0 = util.strain.from_capacitance(cap, Cp=-.0099, d0=56.534);

    %% TAB: Temp vs time
    plot(ax_temp_A, time, TA, 'k-');
    plot(ax_temp_B, time, TB, 'k-');
    
    %% TAB: Kerr
    yyaxis(ax_kerr_dc, 'right');
    plot(ax_kerr_dc, TA, dc, 'b.');
    yyaxis(ax_kerr_dc, 'left');
    plot(ax_kerr_dc, TA, kerr, 'r.-');

    yyaxis(ax_kerr_harm, 'right');
    plot(ax_kerr_harm, TA, r2, 'b-');
    yyaxis(ax_kerr_harm, 'left');
    plot(ax_kerr_harm, TA, x1, 'r-');

    %% TAB: Transport
    yyaxis(ax_tran_temp, 'right');
    plot(ax_tran_temp, TA, strain, 'b-');    
    %plot(ax_tran_temp, TA, strain0, 'b--');
    yyaxis(ax_tran_temp, 'left');
    plot(ax_tran_temp, TA, res, 'r-');

    yyaxis(ax_tran_time, 'right');
    plot(ax_tran_time, time, cap, 'b-');
    yyaxis(ax_tran_time, 'left');
    plot(ax_tran_time, time, res, 'r-');

end