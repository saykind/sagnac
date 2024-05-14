function plot(filename)
%PLOT polarimetry data and calculate fit parameters.
%   If filename is not provided, it looks for 'polarimetry.mat',
%   otherwise user is prompted to select a file.
%
%   This code is based on tutorial from thorlabs:
%   https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=14062#VideoPolarimeterStokes

%theta = 0:5:180;
%I = [1008 991 929 823 690 540 395 259 153 84 61.1 78.8 136 228 328 438 528 600 638 641 607 542 460 366 279 215 182 185 226 305 414 544 680 802 902 976 1004];

    if nargin < 1
        if exist('polarimetry.mat', 'file') == 2
            filename = 'polarimetry.mat';
        else
            filename = util.filename.select();
            filename = filename{1};
        end
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
    xlabel('\theta');
    ylabel('P (\muW)');
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
    fprintf(" A = %6.0f uW.\n B = %6.0f uW.\n C = %6.0f uW.\n D = %6.0f uW.\n\n", A, B, C, D);

    % Plot model fit
    angle_model = min(angle):1:max(angle);
    power_model = 0.5*(A+B*sind(2*angle_model) + C*cosd(4*angle_model) + D*sind(4*angle_model));
    plot(angle_model, power_model, '--', 'LineWidth', 2);

    % Determine whether polarizer was horizontal or vertical
    S0 = A - C;
    sgn = 1;    % 1 for horizontal, -1 for vertical
    if A < S0, sgn = -1; end

    % Display Stokes parameters
    S = [A-C, sgn*2*C, sgn*2*D, sgn*B];
    fprintf(" S0 = %6.0f uW.\n S1 = %6.0f uW.\n S2 = %6.0f uW.\n S3 = %6.0f uW.\n\n", S(1), S(2), S(3), S(4));
    DOP = sqrt(S(2)^2 + S(3)^2 + S(4)^2)/S(1);  % Degree of polarization
    DOLP = sqrt(S(2)^2 + S(3)^2)/S(1);          % Degree of linear polarization
    DOCP = abs(S(4)/S(1));                      % Degree of circular polarization   
    fprintf(" Degree of Polarization           = %.1f %% \n", 100*DOP);
    fprintf(" Degree of Linear Polarization    = %.1f %% \n", 100*DOLP);
    fprintf(" Degree of Circular Polarization  = %4.1f %% \n\n", 100*DOCP);

    psi = 0.5*atand(S(3)/S(2));
    chi = 0.5*atand(S(4)/sqrt(S(2)^2 + S(3)^2));
    p = S(4)./sind(2*chi);
    fprintf(" (major axis)  psi = %.0f deg\n", psi);
    fprintf(" (ellipticity) chi = %.0f deg\n", chi);
    fprintf(" intensity of all light = %.0f uW\n", S(1));
    fprintf(" intensity of polarized light = %.0f uW\n\n", abs(p));

    % Extract Jones vector
    S1 = sqrt(S(2)^2 + S(3)^2 + S(4)^2);
    Ex = sqrt(0.5*(S(2) + S1));
    Ey = sqrt(0.5*(S(2) - S1));
    ph = 0.5*atand(S(4)/S(3));
    fprintf(" Polarized part of light:\n");
    % fprintf(" intensity of polarized light = %.0f uW\n", S1);
    fprintf(" |Ex| = %8.4f uW\n", Ex);
    fprintf(" |Ey| = %8.4f uW\n", Ey);
    fprintf(" ph_x - ph_y = %.0f deg\n", ph);
end

