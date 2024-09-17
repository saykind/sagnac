function qwp()
%Plot polarimetry data and calculate fit parameters.

    filenames = util.filename.select();   

    % Create a figure
    fig = figure("Name", "QWP rotation", "NumberTitle", "off", "Position", [100, 100, 1200, 600]);
    ax = axes(fig);
    hold(ax, 'on');
    box(ax, 'on');
    grid(ax, 'on');
    xlabel('QWP angle (deg)');
    ylabel('Power (\muW)');
    set(ax, 'fontsize', 18);

    for i = 1:numel(filenames)
        filename = filenames{i};
        data = load(filename);
        angle = data.angle;
        power = data.power;
        
        name = strsplit(filename, '\');
        name = name{end};

        %Plot the data
        plot(ax, angle, power, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', lines(1), ...
        'DisplayName', name, 'Tag', name);

        % Stokes parameters extracted from measurement
        N = numel(angle);
        A = mean(power);
        B = 2/N*sum(power.*sind(4*angle));
        C = 2/N*sum(power.*cosd(4*angle));
        % fprintf(" A = %6.0f uW.\n B = %6.0f uW.\n C = %6.0f uW.\n\n", A, B, C);

        % Fit using lsqcurvefit
        x0 = [A, B, C];
        F = @(x, angle) (x(1) + x(2)*sind(4*angle) + x(3)*cosd(4*angle));
        x = lsqcurvefit(F, x0, angle, power, [], [], optimset('Display', 'off'));
        A = x(1);
        B = x(2);
        C = x(3);
        % fprintf(" A = %6.0f uW.\n B = %6.0f uW.\n C = %6.0f uW.\n\n", A, B, C);
        a = A;  % average power
        b = sqrt(B^2 + C^2);    % amplitude of oscillation
        phi = atan2d(C, B);      % phase of oscillation
        min_over_max = 100*(a - b)/(a + b);
        fprintf(" y = a + b*sin(4*x + phi).\n a = %8.1f uW.\n b = %8.1f uW.\n phi = %6.0f deg.\n min/max = %8.2f%% \n\n", a, b, phi, min_over_max);

        % Plot model fit
        angle_model = min(angle):1:max(angle);
        power_model = (A+B*sind(4*angle_model) + C*cosd(4*angle_model));
        plot(ax, angle_model, power_model, '--', 'LineWidth', 2);
    end
    legend(ax, 'show', 'interpreter', 'none');

end

