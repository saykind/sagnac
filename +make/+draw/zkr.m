function graphics = zkr(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.dT (1,1) double = 0;
    options.x1_offset (1,1) double = 0;
end
    %options.x1_offset = .43*1e-6;
    %options.x1_offset = 1.5*1e-6;

    [axis_time_A, axis_time_B, axis_time_C, ...
            axis_temp_a, axis_temp_b, ...
            axis_temp_A, axis_temp_B, axis_temp_C, ...
            axis_power_a, axis_power_b, ...
            axis_res_a, axis_res_b] = util.unpack(graphics.axes);
    for ax = graphics.axes
        yyaxis(ax, 'right'); cla(ax); 
        yyaxis(ax, 'left'); cla(ax);
    end

    t = logdata.timer.time/60;      % Time, min
    TA = logdata.tempcont.A;        % Temp, K
    TB = logdata.tempcont.B;        % Temp, K
    dc = 1e3*logdata.voltmeter.v1;  % DC voltage, mV
    curr = .1;                      % Current, A
    res = 1e3*logdata.lockinA.X/curr;   % Resistance, mOhm
    [x1, y1, x2, y2, r2, kerr] = util.logdata.lockin(logdata.lockin, 'x1_offset', options.x1_offset);


    % Kerr vs Time
    yyaxis(axis_time_A, 'left');
    plot(axis_time_A, t, kerr, 'Color', 'r');
    yyaxis(axis_time_A, 'right');
    plot(axis_time_A, t, dc, 'Color', 'b');

    yyaxis(axis_time_B, 'left');
    plot(axis_time_B, t, x1, 'Color', 'r');
    yyaxis(axis_time_B, 'right');
    plot(axis_time_B, t, y1, 'Color', 'b');

    yyaxis(axis_time_C, 'left');
    plot(axis_time_C, t, r2, 'Color', 'k');

    yyaxis(axis_time_C, 'right');
    coeff = besselj(2,2*.92)/(1+besselj(0,2*.92))*(.673/.25);
    cohernt_ratio = r2./dc/coeff;       % coherent reflection ratio P2/P0 (should be 1)
    plot(axis_time_C, t, cohernt_ratio, 'Color', 'b');

    % Temp vs Time
    yyaxis(axis_temp_a, 'left');
    plot(axis_temp_a, t, TA, 'Color', 'r');
    yyaxis(axis_temp_a, 'right');
    plot(axis_temp_a, t, TB, 'Color', 'b');

    % Kerr vs Temp A
    yyaxis(axis_temp_A, 'left');
    if options.dT
        [Ta, K] = util.coarse.grain(options.dT, TA, kerr);
        plot(axis_temp_A, Ta, K, 'Color', 'r');
    else
        plot(axis_temp_A, TA, kerr, 'Color', 'r');
    end
    yyaxis(axis_temp_A, 'right');
    plot(axis_temp_A, TA, dc, 'Color', 'b');

    yyaxis(axis_temp_B, 'left');
    plot(axis_temp_B, TA, x1, 'Color', 'r');
    yyaxis(axis_temp_B, 'right');
    plot(axis_temp_B, TA, y1, 'Color', 'b');

    yyaxis(axis_temp_C, 'left');
    plot(axis_temp_C, TA, r2, 'Color', 'k');
    yyaxis(axis_temp_C, 'right');
    plot(axis_temp_C, TA, cohernt_ratio, 'Color', 'b');

    % Kerr vs Power
    yyaxis(axis_power_a, 'left');
    plot(axis_power_a, dc, kerr, 'r.');
    yyaxis(axis_power_a, 'right');

    yyaxis(axis_power_b, 'left');
    plot(axis_power_b, dc, x1, 'r.');
    yyaxis(axis_power_b, 'right');

    % Resistance
    yyaxis(axis_res_a, 'left');
    plot(axis_res_a, TA, res, 'r');
    yyaxis(axis_res_a, 'right');

    yyaxis(axis_res_b, 'left');
    plot(axis_res_b, t, res, 'r');
    yyaxis(axis_res_b, 'right');
    
end