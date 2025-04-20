function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax_temp_A, ax_temp_B, ...
        ax_T_kerr, ax_T_1f, ax_T_2f, ...
        ax_t_kerr, ax_t_1f, ax_t_2f] = util.unpack(graphics.axes);
    for ax = [ax_temp_A, ax_temp_B]
        cla(ax);
    end
    for ax = [ax_T_kerr, ax_T_1f, ax_T_2f, ax_t_kerr, ax_t_1f, ax_t_2f]
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    time = logdata.watch.datetime-logdata.watch.datetime(1);
    TA = logdata.tempcont.A;
    TB = logdata.tempcont.B;
    dc = 1e3*logdata.lockin.auxin0(:,1);    
    % Compute kerr angle
    [x1, y1, x2, y2, r1, r2, kerr] = util.logdata.lockin(logdata.lockin);


    %% TAB: Temp vs time
    plot(ax_temp_A, time, TA, 'k-');
    plot(ax_temp_B, time, TB, 'k-');

    %% TAB: Kerr vs temp
    yyaxis(ax_T_kerr, 'right');
    plot(ax_T_kerr, TA, dc, 'b.');
    yyaxis(ax_T_kerr, 'left');
    plot(ax_T_kerr, TA, kerr, 'r.-');

    yyaxis(ax_T_1f, 'right');
    plot(ax_T_1f, TA, y1, 'b-');
    yyaxis(ax_T_1f, 'left');
    plot(ax_T_1f, TA, x1, 'r-');

    yyaxis(ax_T_2f, 'right');
    plot(ax_T_2f, TA, r2./dc, 'b-');
    yyaxis(ax_T_2f, 'left');
    plot(ax_T_2f, TA, r2, 'r-');

    %% TAB: Kerr vs time
    yyaxis(ax_t_kerr, 'right');
    plot(ax_t_kerr, time, dc, 'b.');
    yyaxis(ax_t_kerr, 'left');
    plot(ax_t_kerr, time, kerr, 'r.-');

    yyaxis(ax_t_1f, 'right');
    plot(ax_t_1f, time, y1, 'b-');
    yyaxis(ax_t_1f, 'left');
    plot(ax_t_1f, time, x1, 'r-');

    yyaxis(ax_t_2f, 'right');
    plot(ax_t_2f, time, r2, 'b-');
    yyaxis(ax_t_2f, 'left');
    plot(ax_t_2f, time, r1, 'r-');
    

end