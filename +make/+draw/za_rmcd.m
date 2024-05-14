function graphics = za_rmcd(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.a0 (1,1) double = NaN;            % Proper amplitude, Vpp
    options.verbose (1,1) logical = true;       % Display progress
end 

    %% Unpack the axes
    [axis_dc, axis_kerr, ...
     axis_x1y1, axis_r1q1, ...
     axis_x2y2, axis_r2q2] = util.graphics.unpack(graphics.axes);

    %Unpack data
    A = logdata.sweep.range;                % Amplitude, Vpp
    dc = 1e3*logdata.voltmeter.v1;          % DC voltage, mV
    x1 = 1e6*logdata.lockin.x(:,1);         % 1st harmonic X, uV
    y1 = 1e6*logdata.lockin.y(:,1);         % 1st harmonic Y, uV
    r1 = sqrt(x1.^2 + y1.^2);               % 1f magnitude, mV
    x2 = 1e3*logdata.lockin.x(:,2);         % 2nd harmonic X, mV
    y2 = 1e3*logdata.lockin.y(:,2);         % 2nd harmonic Y, mV
    r2 = sqrt(x2.^2 + y2.^2);               % 2nd harmonic R, uV
    
    q1 = flip(unwrap(flip(atan2(y1, x1))))*180/pi;      % 1f phase, deg
    q2 = flip(unwrap(flip(atan2(y2, x2))))*180/pi;      % 2f phase, deg

    [DC, X1, Y1, X2, Y2, R1, R2, Q1, Q2] = ...
        util.coarse.sweep(logdata.sweep, dc, x1, y1, x2, y2, r1, r2, q1, q2);
    
    A = A(1:length(DC));


    % Plot data
    yyaxis(axis_dc, 'left');
    plot(axis_dc, A, DC, 'k');

    yyaxis(axis_x1y1, 'left');
    plot(axis_x1y1, A, X1, 'r');
    yyaxis(axis_x1y1, 'right');
    plot(axis_x1y1, A, Y1, 'b');

    yyaxis(axis_x2y2, 'left');
    plot(axis_x2y2, A, X2, 'r');
    yyaxis(axis_x2y2, 'right');
    plot(axis_x2y2, A, Y2, 'b');

    yyaxis(axis_r1q1, 'left');
    plot(axis_r1q1, A, R1, 'r');
    yyaxis(axis_r1q1, 'right');
    plot(axis_r1q1, A, Q1, 'b');

    yyaxis(axis_r2q2, 'left');
    plot(axis_r2q2, A, R2, 'r');
    yyaxis(axis_r2q2, 'right');
    plot(axis_r2q2, A, Q2, 'b');

    

end