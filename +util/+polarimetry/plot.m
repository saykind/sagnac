function plot(filename, options)
%PLOT polarimetry data and calculate fit parameters.
%   If filename is not provided, it looks for 'polarimetry.mat',
%   otherwise user is prompted to select a file.
%
%   This code is based on tutorial from thorlabs:
%   https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=14062#VideoPolarimeterStokes

arguments
    filename string = "polarimetry.mat"
    options.polarizer_orientation logical = true    % true for vertical, false for horizontal
end
    
    if exist(filename, 'file') ~= 2
        filenames = util.filename.select();
        filename = filenames{1};
    end

    data = load(filename);
    angle = data.angle;
    power = data.power;

    % Create a figure
    fig = figure("Name", "Polarimetry", "NumberTitle", "off", "Position", [100, 100, 1200, 600]);
    ax = axes(fig);
    hold(ax, 'on');
    box(ax, 'on');
    grid(ax, 'on');
    xlabel('Angle (deg)');
    ylabel('Power (\muW)');
    set(ax, 'fontsize', 18);

    %Plot the data
    plot(ax, angle, power, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', lines(1));

    % Stokes parameters extracted from measurement
    N = numel(angle);
    A = 2/N*sum(power);
    B = 4/N*sum(power.*sind(2*angle));
    C = 4/N*sum(power.*cosd(4*angle));
    D = 4/N*sum(power.*sind(4*angle));
    % fprintf(" A = %6.0f uW.\n B = %6.0f uW.\n C = %6.0f uW.\n D = %6.0f uW.\n\n", A, B, C, D);

    % Fit using lsqcurvefit
    x0 = [A, B, C, D];
    F = @(x, angle) 0.5*(x(1) + x(2)*sind(2*angle) + x(3)*cosd(4*angle) + x(4)*sind(4*angle));
    x = lsqcurvefit(F, x0, angle, power, [], [], optimset('Display', 'off'));
    A = x(1);
    B = x(2);
    C = x(3);
    D = x(4);
    % fprintf(" A = %6.0f uW.\n B = %6.0f uW.\n C = %6.0f uW.\n D = %6.0f uW.\n\n", A, B, C, D);

    % Plot model fit
    angle_model = min(angle):1:max(angle);
    power_model = 0.5*(A+B*sind(2*angle_model) + C*cosd(4*angle_model) + D*sind(4*angle_model));
    plot(angle_model, power_model, '--', 'LineWidth', 2);

    % Determine whether polarizer was horizontal or vertical
    sgn = 1;    % 1 for horizontal, -1 for vertical
    if options.polarizer_orientation, sgn = -1; end

    % Display Stokes parameters
    S = [A-C, sgn*2*C, sgn*2*D, sgn*B];
    fprintf(" S0 = %6.0f uW.\n S1 = %6.0f uW.\n S2 = %6.0f uW.\n S3 = %6.0f uW.\n", S(1), S(2), S(3), S(4));
    S1 = sqrt(S(2)^2 + S(3)^2 + S(4)^2);        % Intensity of polarized light
    DOP = S1/S(1);                              % Degree of polarization
    DOLP = (S(2)^2 + S(3)^2)/S1^2;                % Degree of linear polarization
    DOCP = (S(4)/S1)^2;                         % Degree of circular polarization   
    fprintf(" Degree of Polarization           = %.1f %% \n\n", 100*DOP);
    
    % Extract polarization parameters
    fprintf(" Polarized part of light:\n");
    fprintf(" intensity of polarized light = %.0f uW\n", S1);
    fprintf(" intensity of all light = %.0f uW\n", S(1));
    fprintf(" Degree of Linear Polarization    = %.1f %% \n", 100*DOLP);
    fprintf(" Degree of Circular Polarization  = %4.1f %% \n\n", 100*DOCP);

    % Extract Jones vector
    Ex = sqrt(0.5*(S1 + S(2)));
    Ey = sqrt(0.5*(S1 - S(2)));
    ph = 0.5*atan2d(S(4), S(3));
    
    % fprintf(" intensity of polarized light = %.0f uW\n", S1);
    fprintf(" |Ex| = %8.4f uW\n", Ex);
    fprintf(" |Ey| = %8.4f uW\n", Ey);
    fprintf(" ph_x - ph_y = %.0f deg\n", ph);

    psi = 0.5*atan2d(S(3), S(2));                   % Major axis of polarization ellipse
    chi = 0.5*atan2d(S(4), sqrt(S(2)^2 + S(3)^2));  % Ellipticity
    fprintf(" Major axis angle (psi) = %.0f deg\n", psi);
    fprintf(" Ellipticity (chi) = %.0f deg\n", chi);
end

