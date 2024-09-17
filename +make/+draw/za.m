function graphics = za(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.x1_offset (1,1) double = 0;
    options.a0 (1,1) double = NaN;            % Proper amplitude, Vpp
    options.f_over_f0 (1,1) double = 1;         % Frequency f over proper frequency f0
    % options.kerr0 (1,1) double = -6.5e-6;       % Assumed Kerr signal, rad
    % options.kerr0 (1,1) double = .335;       % Assumed Kerr signal, rad
    options.kerr0 (1,1) double = NaN;       % Assumed Kerr signal, rad
    options.dc_offset (1,1) double = 0;      % DC offset, mV
    options.verbose (1,1) logical = true;       % Display progress
end 

    %% Unpack the axes
    [axis_dc, axis_kerr, ...
     axis_x1y1, axis_r1q1, ...
     axis_x2y2, axis_r2q2] = util.graphics.unpack(graphics.axes);

    %Unpack data
    A = logdata.sweep.range;            % Amplitude, Vpp
    dc = 1e3*logdata.voltmeter.v1;      % DC voltage, mV
    [x1, y1, x2, y2, r1, r2, kerr] = ...
        util.logdata.lockin(logdata.lockin, 'x1_offset', options.x1_offset);
    r1 = sqrt(x1.^2 + y1.^2);       % 1f magnitude, mV
    q1 = flip(unwrap(flip(atan2(y1, x1))))*180/pi;      % 1f phase, deg
    q2 = flip(unwrap(flip(atan2(y2, x2))))*180/pi;      % 2f phase, deg
    [DC, X1, Y1, X2, Y2, R1, R2, Q1, Q2] = ...
        util.coarse.sweep(logdata.sweep, dc, x1, y1, x2, y2, r1, r2, q1, q2);
    A = A(1:length(DC));

    if ~isnan(options.dc_offset)
        dc_offset = options.dc_offset;
        DC = DC - dc_offset;
    end


    % Plot data
    yyaxis(axis_dc, 'left');
    plot(axis_dc, A, DC, 'k');
    yyaxis(axis_dc, 'right');
    plot(axis_dc, A(2:end), R2(2:end)./(DC(2:end)-DC(1)), 'b');

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

    %% Model data and compute kerr, ac_responsivity
    if isnan(options.a0), return; end
    a0 = options.a0;

    % Compute kerr
    kerr_A = util.math.kerr_a(1e-3*X1, R2, A, a0);
    plot(axis_kerr, A, kerr_A, 'r');
    kerr_A = 1e-6*kerr_A;  % Convert to rad
    % xlim(axis_kerr, a0*[.3, 1.65]);

    A_idx = 0.4 < A & A < 1.5;
    if isempty(A_idx)
        kerr0 = NaN;
    else
        kerr0 = mean(kerr_A(A_idx));
        kerr0_std = std(kerr_A(A_idx));
        if options.verbose
            disp(['Kerr = ', num2str(fix(1e6*kerr0)), ' +/- ', num2str(fix(1e6*kerr0_std)), ' urad.']);
        end
    end
    
    if ~isnan(options.kerr0), kerr0 = options.kerr0; end

    if isnan(kerr0), return; end

    cos2kerr0 = cos(2*kerr0);
    sin2kerr0 = sin(2*kerr0);

    plot(axis_kerr, A, 1e6*kerr0*ones(size(A)), 'r--');
    if sign(kerr0) == -1
        ylim(axis_kerr, 1e6*kerr0*[1.7,.5]);
    else
        ylim(axis_kerr, 1e6*kerr0*[.5,1.7]);
    end

    % Find AC responsivity
    A_fit_idx = 0.8 < A & A < 3;
    if isempty(A_fit_idx)
        ac_dc = 1;
    else
        A_fit = A(A_fit_idx);
        delta_coherent_ratio_model_fit = 2*abs(besselj(2, 1.841*A_fit/a0))./(besselj(0, 1.841*A_fit/a0)-1);
        delta_coherent_ratio_data_fit = R2(A_fit_idx)./(DC(A_fit_idx)-DC(1));
        ac_dc = mean(delta_coherent_ratio_data_fit./delta_coherent_ratio_model_fit);
        ac_dc_std = std(delta_coherent_ratio_data_fit./delta_coherent_ratio_model_fit);
        if options.verbose
            disp(['AC/DC = ', num2str(ac_dc), ' +/- ', num2str(ac_dc_std)]);
        end
    end
    delta_coherent_ratio_model = ac_dc*2*abs(besselj(2, 1.841*A/a0))./(besselj(0, 1.841*A/a0)-1);

    yyaxis(axis_dc, 'right');
    plot(axis_dc, A, delta_coherent_ratio_model, 'b--');

    % Find I0 and birefringence
    delta_dc_model_fit = (besselj(0, 1.841*A_fit/a0)-1)*cos2kerr0;
    delta_dc_data_fit = DC(A_fit_idx)-DC(1);
    I0 = mean(delta_dc_data_fit./delta_dc_model_fit);
    I0_std = std(delta_dc_data_fit./delta_dc_model_fit);
    if options.verbose
        disp(['I0 = ', num2str(I0), ' +/- ', num2str(I0_std)]);
    end

    birefringence = DC(1)/I0 - 1 - cos2kerr0;
    if options.verbose
        disp(['Birefringence = ', num2str(birefringence)]);
    end

    % Model data
    DC_model = I0*(birefringence + 1 + besselj(0, 1.841*A/a0)*cos2kerr0);

    yyaxis(axis_dc, 'left');
    plot(axis_dc, A, DC_model, 'k--');    

    R2_model = abs(I0*2*besselj(2, 1.841*A/a0)*cos2kerr0*ac_dc);
    yyaxis(axis_r2q2, 'left');
    plot(axis_r2q2, A, R2_model, 'r--');
    
    x1_model = 1e3*sin2kerr0*I0*2*besselj(1, 1.841*A/a0)*ac_dc;
    yyaxis(axis_x1y1, 'left');
    plot(axis_x1y1, A, x1_model, 'r--');
    yyaxis(axis_r1q1, 'left');
    plot(axis_r1q1, A, abs(x1_model), 'r--');
end