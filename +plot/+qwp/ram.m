function [fig, ax] = ram(options)
%LOCKIN plots lockin data vs waveplate angle.
%
%   Output Arguments:
%   - fig           : Graphics handle.
%   - ax            : Axes handle.
%
%   Notes:
%   - The function assumes that 
%       logdata.lockin.auxin0 = power-x
%       logdata.lockin.auxin1 = power-y
%
%   See also util.polarimetry.plot();

    arguments
        options.filenames string = [];
        options.fig = [];
        options.scale double {mustBeNumeric} = 1;
        options.xlim double {mustBeNumeric} = [0,180];
        options.show_legend logical = false;
        options.legends string = [];
        options.save logical = true;
        options.verbose logical = false;
    end

    filenames = options.filenames;
    legends = options.legends;
    verbose = options.verbose;
    min_angle = options.xlim(1);
    max_angle = options.xlim(2);

    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = convertCharsToStrings(util.filename.select());
        %filenames = flip(filenames);
    end
    if isempty(filenames)
        util.msg('No file selected.');
        return;
    end

    % Create figure
    if isempty(options.fig)
        [fig, ax] = plot.paper.graphics(...
            title = "Rotating QWP test", ...
            single_yticks = true, ...
            subplots = [3,1], ...
            xlim = [min_angle, max_angle], ...
            xlabel = "QWP angle (deg)" ...
            );
        % Format plot
        ylabel(ax(1), 'R_0 (mV)');
        ylabel(ax(2), 'R_1 (uV)');
        ylabel(ax(3), 'R_2 (mV)');
        if ~isnan(options.xlim), xlim(options.xlim); end
        set(ax(1), 'Clipping', 'off');
        set(ax(2), 'Clipping', 'off');
        set(ax(3), 'Clipping', 'off');
        % Set xticks with 15 degree step
        xticks(ax(1), min_angle:15:max_angle);
        xticks(ax(2), min_angle:15:max_angle);
        xticks(ax(3), min_angle:15:max_angle);
        % Set xticks labels with 30 degree step
        xticklabels(ax(3), ["0", "", "30", "", "60", "", "90", "", "120", "", "150", "", "180", "", "210", "", "240", "", "270", "", "300", "", "330", "", "360"]);
    else
        fig = options.fig;
        ax = fig.Children;
    end

    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        data = load(filename);
        logdata = data.logdata;
        loginfo = data.loginfo;
        
        % Extract data
        try
            angle = logdata.waveplate.angle;
        catch ME
            util.msg('No waveplate angle information found.');
            return;
        end
        x1 = 1e6*logdata.lockin.x(:,1);
        y1 = 1e6*logdata.lockin.y(:,1);
        r1 = sqrt(x1.^2 + y1.^2);
        q1 = atan2d(y1, x1);
        x2 = 1e3*logdata.lockin.x(:,2);
        y2 = 1e3*logdata.lockin.y(:,2);
        r2 = sqrt(x2.^2 + y2.^2);
        q2 = atan2d(y2, x2);
        x3 = 1e3*logdata.lockin.x(:,3);
        y3 = 1e3*logdata.lockin.y(:,3);
        r3 = sqrt(x3.^2 + y3.^2);
        q3 = atan2d(y3, x3);
        aux1 = 1e3*logdata.lockin.auxin0(:,1);


        % Coarse-grain
        try
            sweep = data.loginfo.sweep;
        catch ME
            util.msg('No sweep information found.');
            sweep = struct('rate', 10, 'pause', 6);
        end
        [A, R0, R1, R2] = util.coarse.sweep(sweep, angle, aux1, r1, r2);

        %% R0 vs angle
        % Fourier initial guess
        power = R0;
        N = numel(power);
        F0 = 1/N*sum(power);
        F4s = 2/N*sum(power.*sind(4*A));
        F4c = 2/N*sum(power.*cosd(4*A));

        % Fourier fit
        x0 = [F0, F4c, F4s];
        F = @(x, angle) x(1) + x(2)*cosd(4*angle) + x(3)*sind(4*angle);
        x = lsqcurvefit(F, x0, A, power, [], [], optimset('Display', 'off'));
        F0 = x(1);
        F4c = x(2);
        F4s = x(3);
        power_ideal = F0 + F4c*cosd(4*A) + F4s*sind(4*A);
        % Display Fourier coefficients
        if verbose
            fprintf("R0:\tF0 + F4*cos(4A+f4)\n");
            fprintf("\tF0 = %6.1f mV.\n", F0);
            fprintf("\tF4 = %6.1f mV.\n", sqrt(F4c^2 + F4s^2));
            fprintf("\tf4 = %6.1f deg.\n", -atan2d(F4s, F4c));
        end

        plot(ax(1), A, R0, 'k.', 'MarkerSize', 5);
        plot(ax(1), A, power_ideal, 'b--', 'LineWidth', 1);

        %% R1 vs angle
        % Fourier initial guess
        power = R1;
        N = numel(power);
        F0 = 1/N*sum(power);
        F4s = 2/N*sum(power.*sind(4*A));
        F4c = 2/N*sum(power.*cosd(4*A));

        % Fourier fit
        x0 = [F0, F4c, F4s];
        F = @(x, angle) x(1) + x(2)*cosd(4*angle) + x(3)*sind(4*angle);
        x = lsqcurvefit(F, x0, A, power, [], [], optimset('Display', 'off'));
        F0 = x(1);
        F4c = x(2);
        F4s = x(3);
        power_ideal = F0 + F4c*cosd(4*A) + F4s*sind(4*A);
        % Display Fourier coefficients
        if verbose
            fprintf("R1:\tF0 + F4*cos(4A+f4)\n");
            fprintf("\tF0 = %6.1f uV.\n", F0);
            fprintf("\tF4 = %6.1f uV.\n", sqrt(F4c^2 + F4s^2));
            fprintf("\tf4 = %6.1f deg.\n", -atan2d(F4s, F4c));
        end

        plot(ax(2), A, R1, 'k.', 'MarkerSize', 5);
        plot(ax(2), A, power_ideal, 'b--', 'LineWidth', 1);

        %% R2 vs angle
        % Fourier initial guess
        power = R2;
        N = numel(power);
        F0 = 1/N*sum(power);
        F4s = 2/N*sum(power.*sind(4*A));
        F4c = 2/N*sum(power.*cosd(4*A));

        % Fourier fit
        x0 = [F0, F4c, F4s];
        F = @(x, angle) x(1) + x(2)*cosd(4*angle) + x(3)*sind(4*angle);
        x = lsqcurvefit(F, x0, A, power, [], [], optimset('Display', 'off'));
        F0 = x(1);
        F4c = x(2);
        F4s = x(3);
        power_ideal = F0 + F4c*cosd(4*A) + F4s*sind(4*A);
        % Display Fourier coefficients
        if verbose
            fprintf("R2:\tF0 + F4*cos(4A+f4)\n");
            fprintf("\tF0 = %6.1f mV.\n", F0);
            fprintf("\tF4 = %6.1f mV.\n", sqrt(F4c^2 + F4s^2));
            fprintf("\tf4 = %6.1f deg.\n", -atan2d(F4s, F4c));
        end

        plot(ax(3), A, R2, 'k.', 'MarkerSize', 5);
        plot(ax(3), A, power_ideal, 'b--', 'LineWidth', 1);
    end

    % Save figure
    if options.save
        [~, name, ~] = fileparts(filenames(1));
        save_filename = fullfile('output', strcat(name, '_angle.png'));
        if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
        saveas(fig, save_filename, 'png');
    end
    