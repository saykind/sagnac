function graphics = zfa(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.x1_offset (1,1) double = 0;
end 

    %% Unpack the axes
    [axis_dc, axis_kerr, ...
     axis_x1, axis_y1, ...
     axis_x2, axis_y2, ...
     axis_r1, axis_r2] = util.graphics.unpack(graphics.axes);

    %Unpack data
    dc = 1e3*logdata.voltmeter.v1;      % DC voltage, mV
    [x1, y1, x2, y2, r2, kerr] = ...
        util.logdata.lockin(logdata.lockin, 'x1_offset', options.x1_offset);
    r1 = sqrt(x1.^2 + y1.^2);       % 1f magnitude, mV
    [DC, X1, Y1, X2, Y2, R1, R2, KERR] = ...
        util.coarse.sweep(logdata.sweep, dc, x1, y1, x2, y2, r1, r2, kerr);

    % Fill rest of the data with the last value


    % Reshape data
    shape = logdata.sweep.shape;
    f = logdata.sweep.range(1,:)*1e-6;  % Frequency, MHz
    a = logdata.sweep.range(2,:);       % Amplitude, V
    [F, A, DC, X1, Y1, X2, Y2, R1, R2, KERR] = ...
        util.mesh.reshape(shape, f, a, DC, X1, Y1, X2, Y2, R1, R2, KERR);

    % Plot data
    surf(axis_dc, F, A, DC, 'EdgeAlpha', .2);
    surf(axis_kerr, F, A, KERR, 'EdgeAlpha', .2);
    surf(axis_x1, F, A, X1, 'EdgeAlpha', .2);
    surf(axis_y1, F, A, Y1, 'EdgeAlpha', .2);
    surf(axis_x2, F, A, X2, 'EdgeAlpha', .2);
    surf(axis_y2, F, A, Y2, 'EdgeAlpha', .2);
    surf(axis_r1, F, A, R1, 'EdgeAlpha', .2);
    surf(axis_r2, F, A, R2, 'EdgeAlpha', .2);

end