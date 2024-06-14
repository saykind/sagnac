function graphics = zf(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.f0 (1,1) double = 12.285; %3.857;            % Proper frequency, MHz
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
    x2 = 1e6*logdata.lockin.x(:,2);         % 2nd harmonic X, uV
    y2 = 1e6*logdata.lockin.y(:,2);         % 2nd harmonic Y, uV
    r2 = sqrt(x2.^2 + y2.^2);               % 2nd harmonic R, uV
    
    q1 = flip(unwrap(flip(atan2(y1, x1))))*180/pi;      % 1f phase, deg
    q2 = flip(unwrap(flip(atan2(y2, x2))))*180/pi;      % 2f phase, deg

    [DC, X1, Y1, X2, Y2, R1, R2, Q1, Q2] = ...
        util.coarse.sweep(logdata.sweep, dc, x1, y1, x2, y2, r1, r2, q1, q2);
    X1 = X1./DC;    % 10^3 multiplier included
    Y1 = Y1./DC;
    X2 = X2./DC;
    Y2 = Y2./DC;
    R1 = R1./DC;
    R2 = R2./DC;
    
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

    if length(F) < 10, return; end
    if isnan(options.f0), return; end

    % Fit 1f data
    F_fit_idx = F > 1.008*options.f0 & F < 2.5*options.f0;
    F_fit = F(F_fit_idx);
    Q1_fit = Q1(F_fit_idx);
    %linear fit
    p = polyfit(F_fit, Q1_fit, 1);
    Q1_model = polyval(p, F);
    fp = 90/p(1);
    disp("(1f)f_p = " + fp + " MHz");
    yyaxis(axis_r1q1, 'right');
    plot(axis_r1q1, F, Q1_model, 'b--');

    R1_model = abs(cos((pi/2)*F/options.f0));
    R1_fit = R1(F_fit_idx);
    R1_model_fit = R1_model(F_fit_idx);
    A = mean(R1_fit./R1_model_fit);
    Delta_R = min(R1)/A;
    % Fit using lsqcurvefit
    x0 = [A, options.f0];
    F_func = @(x, F_vals) x(1)*sqrt( (cos((pi/2)*F_vals/x(2))).^2 + Delta_R^2 );
    x = lsqcurvefit(F_func, x0, F, R1, [], [], optimset('Display', 'off'));
    A = x(1);
    f0 = x(2);
    Delta_R = min(R1)/A;
    print(class(f0))
    disp("(fit) f_0 = " + f0 + " MHz");
    disp("(fit) A/DC = " + A + " uV  " + "R/DC*10^3 = A*abs(cos((pi/2)*f/f0)");
    disp("(fit) Delta_R = " + Delta_R);
    disp("(fit) Delta_R*A = " + Delta_R*A + " uV");

    F_model = min(F):.004:max(F);
    R1_model = A*abs(cos((pi/2)*F_model/f0));
    R1_Delta_model = A*sqrt( (cos((pi/2)*F_model/f0)).^2 + Delta_R^2 );

    yyaxis(axis_r1q1, 'left');
    plot(axis_r1q1, F_model, R1_model, 'r--');
    plot(axis_r1q1, F_model, R1_Delta_model, 'g--');

    % Fit 2f data
    F_fit_idx = F > .5*options.f0 & F < 1.5*options.f0;
    F_fit = F(F_fit_idx);
    Q2_fit = Q2(F_fit_idx);
    %linear fit
    p2 = polyfit(F_fit, Q2_fit, 1);
    Q2_model = polyval(p2, F);
    fp2 = 180/p2(1);
    disp("(2f) f_p = " + fp2 + " MHz");
    yyaxis(axis_r2q2, 'right');
    plot(axis_r2q2, F, Q2_model, 'b--');

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