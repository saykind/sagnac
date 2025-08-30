function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax_A, ax_B, ax_C] = util.unpack(graphics.axes);
    %for ax = [ax_temp_A, ax_temp_B]
    %    cla(ax);
    %end
    for ax = [ax_A, ax_B, ax_C]
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    TA = logdata.tempcont.A;
    TB = logdata.tempcont.B;

    time = logdata.watch.datetime-logdata.watch.datetime(1);
    % extract minutes from datetime
    time = minutes(time-time(1));

    
    curr = logdata.magnet.I;    % Amps
    volt = logdata.magnet.V;    % Volts
    coil_const = 100;   % mT/A    
    field = coil_const*curr; % mT
    
    dc = 1e3*logdata.lockin.auxin0(:,1);    
    % Compute kerr angle
    [x1, y1, x2, y2, r1, r2, kerr] = util.logdata.lockin(logdata.lockin);
    

    yyaxis(ax_A, 'right');
    plot(ax_A, field, y1, 'b.-');
    yyaxis(ax_A, 'left');
    plot(ax_A, field, x1, 'r.-');

    yyaxis(ax_B, 'right');
    plot(ax_B, field, TB, 'b-');
    yyaxis(ax_B, 'left');
    plot(ax_B, field, TA, 'r-');

    yyaxis(ax_C, 'right');
    plot(ax_C, time, volt, 'b-');
    yyaxis(ax_C, 'left');
    plot(ax_C, time, curr, 'r-');

end