function graphics = zf_kerr(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.f0 (1,1) double = NaN;          % Proper frequency, MHz
    options.verbose (1,1) logical = true;       % Display progress
end 

    %% Unpack the axes
    [axis_dc, axis_kerr, ...
     axis_x1y1, axis_r1q1, ...
     axis_x2y2, axis_r2q2] = util.graphics.unpack(graphics.axes);

    %Unpack data
    F = 1e-6*logdata.sweep.range;           % Frequency, MHz
    dc = 1e3*logdata.voltmeter.v1;          % DC voltage, mV
    x1 = 1e6*logdata.lockin.x(:,1);         % 1st harmonic X, uV
    y1 = 1e6*logdata.lockin.y(:,1);         % 1st harmonic Y, uV
    r1 = sqrt(x1.^2 + y1.^2);               % 1f magnitude, mV
    x2 = 1e3*logdata.lockin.x(:,2);         % 2nd harmonic X, mV
    y2 = 1e3*logdata.lockin.y(:,2);         % 2nd harmonic Y, mV
    r2 = sqrt(x2.^2 + y2.^2);               % 2nd harmonic R, mV
    
    q1 = flip(unwrap(flip(atan2(y1, x1))))*180/pi;      % 1f phase, deg
    q2 = flip(unwrap(flip(atan2(y2, x2))))*180/pi;      % 2f phase, deg

    [DC, X1, Y1, X2, Y2, R1, R2, Q1, Q2] = ...
        util.coarse.sweep(logdata.sweep, dc, x1, y1, x2, y2, r1, r2, q1, q2);
    
    F = F(1:length(DC));


    % Plot data
    yyaxis(axis_dc, 'left');
    plot(axis_dc, F, DC, 'k');

    yyaxis(axis_x1y1, 'left');
    plot(axis_x1y1, F, X1, 'r');
    yyaxis(axis_x1y1, 'right');
    plot(axis_x1y1, F, Y1, 'b');

    yyaxis(axis_x2y2, 'left');
    plot(axis_x2y2, F, X2, 'r');
    yyaxis(axis_x2y2, 'right');
    plot(axis_x2y2, F, Y2, 'b');

    yyaxis(axis_r1q1, 'left');
    plot(axis_r1q1, F, R1, 'r');
    yyaxis(axis_r1q1, 'right');
    plot(axis_r1q1, F, Q1, 'b');

    yyaxis(axis_r2q2, 'left');
    plot(axis_r2q2, F, R2, 'r');
    yyaxis(axis_r2q2, 'right');
    plot(axis_r2q2, F, Q2, 'b');

    if length(F) < 100, return; end
    if isnan(options.f0), return; end

    % Fit 2f data
    % Model for Phase Q
    F_fit_idx = F > .5*options.f0 & F < 1.5*options.f0;
    F_fit = F(F_fit_idx);
    Q2_fit = Q2(F_fit_idx);
    p2 = polyfit(F_fit, Q2_fit, 1);
    Q2_model = polyval(p2, F);
    fp2 = 180/p2(1);
    disp("(2f) f_p = " + fp2 + " MHz");
    yyaxis(axis_r2q2, 'right');
    plot(axis_r2q2, F, Q2_model, 'b--');

    % Model for magnitude R
    R2_model = besselj(2, 2*pi*F/fp2)*mean(R2(12.299 < F & F < 12.301));

    % Model for X and Y
    fp = -3.7584;
    disp("(1f)f_p = " + fp + " MHz");
    X1_model = -A*cos((pi/2)*F/f0).*cos((pi/2)*F/fp) + mean(X1(12.299 < F & F < 12.301));
    Y1_model = -A*cos((pi/2)*F/f0).*sin((pi/2)*F/fp) + mean(Y1(12.299 < F & F < 12.301));

    yyaxis(axis_x1y1, 'left');
    plot(axis_x1y1, F, X1_model, 'r--');
    yyaxis(axis_x1y1, 'right');
    plot(axis_x1y1, F, Y1_model, 'b--');

end