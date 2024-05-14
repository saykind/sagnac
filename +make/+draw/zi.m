function graphics = zi(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.dT (1,1) double = 0;
    options.x1_offset (1,1) double = 0;
    options.coil_const (1,1) double = 25;   % mT/A
end 

    %% Unpack the axes
    [axis_curr_a, axis_curr_b, axis_curr_c, ...
     axis_dc_a, axis_dc_b, axis_dc_c] = ...
     util.graphics.unpack(graphics.axes);

    %Unpack data
    curr = logdata.diode.I;               % Laser curr, mA
    dc = 1e3*logdata.voltmeter.v1;      % DC voltage, mV
    [x1, y1, x2, y2, r2, kerr] = ...
        util.logdata.lockin(logdata.lockin, 'x1_offset', options.x1_offset);
    [CURR, DC, X1, Y1, X2, Y2, R2, KERR, ...
     CURR_std, DC_std, X1_std, Y1_std, X2_std, Y2_std, R2_std, KERR_std] = ...
     util.coarse.sweep(logdata.sweep, curr, dc, x1, y1, x2, y2, r2, kerr);
    R1 = sqrt(X1.^2 + Y1.^2);

    % Current axis
    yyaxis(axis_curr_a, 'left');
    errorbar(axis_curr_a, CURR, KERR, KERR_std, 'r');
    yyaxis(axis_curr_a, 'right');
    plot(axis_curr_a, CURR, DC, 'b.-');

    yyaxis(axis_curr_b, 'left');
    errorbar(axis_curr_b, CURR, X1, X1_std, 'r');
    yyaxis(axis_curr_b, 'right');
    errorbar(axis_curr_b, CURR, Y1, Y1_std, 'b');

    yyaxis(axis_curr_c, 'left');
    plot(axis_curr_c, CURR, X2, 'r.-');
    yyaxis(axis_curr_c, 'right');
    plot(axis_curr_c, CURR, Y2, 'b.-');

    % DC voltage
    yyaxis(axis_dc_a, 'left');
    errorbar(axis_dc_a, DC, KERR, KERR_std, 'r.-');

    yyaxis(axis_dc_b, 'left');
    errorbar(axis_dc_b, DC, X1, X1_std, 'r.-');
    yyaxis(axis_dc_b, 'right');
    errorbar(axis_dc_b, DC, Y1, Y1_std, 'b.-');

    yyaxis(axis_dc_c, 'left');
    plot(axis_dc_c, DC, R2, 'r.-');
    yyaxis(axis_dc_c, 'right');
    plot(axis_dc_c, DC, R1, 'b.-');

end