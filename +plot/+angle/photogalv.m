function [fig, ax] = photogalv(options)
%DC plots lockin DC voltage (reflectivity) vs waveplate angle.
%
%   Output Arguments:
%   - fig           : Graphics handle.
%   - ax            : Axes handle.
%
%   Notes:
%   - The function assumes that 
%       logdata.lockin.auxin0 = dc-voltage
%
%   See also util.polarimetry.plot();

    arguments
        options.filenames string = [];
        options.ax = [];
        options.scale double {mustBeNumeric} = 1;
        options.xlim double {mustBeNumeric} = NaN;
        options.ylim double {mustBeNumeric} = NaN;
        options.show_legend logical = false;
        options.legends string = [];
        options.save logical = true;
        options.verbose logical = true;
    end

    filenames = options.filenames;
    ax = options.ax;
    legends = options.legends;
    verbose = options.verbose;

    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = convertCharsToStrings(util.filename.select());
        %filenames = flip(filenames);
    end
    if isempty(filenames)
        warning('No file selected.');
        return;
    end

    % Create figure
    min_angle = 0;
    step_angle = 60;
    max_angle = 360;
    if isempty(ax)
        [fig, ax] = plot.paper.graphics(...
            subplots = [2,1], ...
            xlim = [min_angle, max_angle], ...
            xlabel = "QWP angle (deg)" ...
            );
    else
        fig = get(ax, 'Parent');
    end
    xticks(ax(1), min_angle:step_angle:max_angle);
    xticks(ax(2), min_angle:step_angle:max_angle);

    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        data = load(filename);
        logdata = data.logdata;
        loginfo = data.loginfo;
        
        % Extract data
        angle = logdata.waveplate.angle;
        ixx = 1e12*logdata.lockinA.X;
        ixxY = 1e12*logdata.lockinA.Y;
        vxx = 1e6*logdata.lockinB.X;
        vxxY = 1e6*logdata.lockinB.Y;

        % Coarse-grain
        sweep = logdata.sweep;
        [A, Ixx, Vxx] = util.coarse.sweep(sweep, angle, ixx, vxx);

        %% Plot Ixx
        % Fourier
        power = Ixx;
        N = numel(power);
        F0 = 1/N*sum(power);
        F1s = 2/N*sum(power.*sind(A));
        F1c = 2/N*sum(power.*cosd(A));
        F2s = 2/N*sum(power.*sind(2*A));
        F2c = 2/N*sum(power.*cosd(2*A));
        F4s = 2/N*sum(power.*sind(4*A));
        F4c = 2/N*sum(power.*cosd(4*A));
        F6c = 2/N*sum(power.*cosd(6*A));
        F6s = 2/N*sum(power.*sind(6*A));
        power_ideal0 = F0 + F1s*sind(A) + F1c*cosd(A) + F2s*sind(2*A) + F2c*cosd(2*A) + F4s*sind(4*A) + F4c*cosd(4*A) + F6s*sind(6*A) + F6c*cosd(6*A);
        % Display Fourier coefficients
        if verbose
            F1 = sqrt(F1s^2 + F1c^2);
            F2 = sqrt(F2s^2 + F2c^2);
            F4 = sqrt(F4s^2 + F4c^2);
            F6 = sqrt(F6s^2 + F6c^2);
            fprintf(" Ixx:\n");
            fprintf("F0 = %6.4f.\n", F0);
            fprintf("F1 = %6.4f.\n", F1);
            fprintf("F2 = %6.4f.\n", F2);
            fprintf("F4 = %6.4f.\n", F4);
            fprintf("F6 = %6.4f.\n", F6);
        end

        % Fourier fit
        x0 = [F0, F2c, F2s, F4c, F4s];
        F = @(x, angle) x(1) ...
            + x(2)*cosd(2*angle) + x(3)*sind(2*angle) ...
            + x(4)*cosd(4*angle) + x(5)*sind(4*angle);
        x = lsqcurvefit(F, x0, A, power, [], [], optimset('Display', 'off'));
        F0 = x(1);
        F2c = x(2);
        F2s = x(3);
        F4c = x(4);
        F4s = x(5);
        
        F2 = sqrt(F2s^2 + F2c^2);
        phi2 = atan2d(F2s, F2c);
        F4 = sqrt(F4s^2 + F4c^2);
        phi4 = atan2d(F4s, F4c);

        power_ideal = F0 + F2*cosd(2*A-phi2) + F4*cosd(4*A-phi4);
        % Display Fourier coefficients
        if verbose
            fprintf("\n");
            fprintf("F0 = %6.4f.\n", F0);
            fprintf("F2 = %6.4f.\n", F2);
            fprintf("phi2 = %6.0f.\n", phi2);
            fprintf("F4 = %6.4f.\n", F4);
            fprintf("phi4 = %6.0f.\n", phi4);
        end

        plot(ax(1), A, Ixx, 'r.', 'MarkerSize', 8);
        plot(ax(1), A, power_ideal, 'r--', 'LineWidth', 1);

        %% Plot Vxx
        % Fourier
        power = Vxx;
        N = numel(power);
        F0 = 1/N*sum(power);
        F1s = 2/N*sum(power.*sind(A));
        F1c = 2/N*sum(power.*cosd(A));
        F2s = 2/N*sum(power.*sind(2*A));
        F2c = 2/N*sum(power.*cosd(2*A));
        F4s = 2/N*sum(power.*sind(4*A));
        F4c = 2/N*sum(power.*cosd(4*A));
        F6c = 2/N*sum(power.*cosd(6*A));
        F6s = 2/N*sum(power.*sind(6*A));
        power_ideal0 = F0 + F1s*sind(A) + F1c*cosd(A) + F2s*sind(2*A) + F2c*cosd(2*A) + F4s*sind(4*A) + F4c*cosd(4*A) + F6s*sind(6*A) + F6c*cosd(6*A);
        % Display Fourier coefficients
        if verbose
            F1 = sqrt(F1s^2 + F1c^2);
            F2 = sqrt(F2s^2 + F2c^2);
            F4 = sqrt(F4s^2 + F4c^2);
            F6 = sqrt(F6s^2 + F6c^2);
            fprintf("\n\n Vxx:\n");
            fprintf("F0 = %6.4f.\n", F0);
            fprintf("F1 = %6.4f.\n", F1);
            fprintf("F2 = %6.4f.\n", F2);
            fprintf("F4 = %6.4f.\n", F4);
            fprintf("F6 = %6.4f.\n", F6);
        end

        % Fourier fit
        x0 = [F0, F1c, F1s, F2c, F2s, F4c, F4s, F6c, F6s];
        F = @(x, angle) x(1) ...
            + x(2)*cosd(2*angle) + x(3)*sind(2*angle) ...
            + x(4)*cosd(4*angle) + x(5)*sind(4*angle);
        x = lsqcurvefit(F, x0, A, power, [], [], optimset('Display', 'off'));
        F0 = x(1);
        F2c = x(2);
        F2s = x(3);
        F4c = x(4);
        F4s = x(5);
        
        F2 = sqrt(F2s^2 + F2c^2);
        phi2 = atan2d(F2s, F2c);
        F4 = sqrt(F4s^2 + F4c^2);
        phi4 = atan2d(F4s, F4c);

        power_ideal = F0 + F2*cosd(2*A-phi2) + F4*cosd(4*A-phi4);
        % Display Fourier coefficients
        if verbose
            fprintf("\n");
            fprintf("F0 = %6.4f.\n", F0);
            fprintf("F2 = %6.4f.\n", F2);
            fprintf("phi2 = %6.0f.\n", phi2);
            fprintf("F4 = %6.4f.\n", F4);
            fprintf("phi4 = %6.0f.\n", phi4);
        end

        plot(ax(2), A, Vxx, 'b.', 'MarkerSize', 8);
        plot(ax(2), A, power_ideal, 'b--', 'LineWidth', 1);
    end

    % Format plot
    ylabel(ax(1), 'I_{xx}^{rms} (pA)');
    ylabel(ax(2), 'V_{xx}^{rms} (uV)');
    if ~isnan(options.ylim), ylim(options.ylim); end


    if ~isnan(options.xlim), xlim(options.xlim); end
    if options.show_legend, l = legend(ax(2), 'Location', 'best'); set(l, 'Interpreter', 'none'); end
    if ~isempty(legends), legend(ax(2), legends, 'Location', 'best'); end
    set(ax(2), 'Clipping', 'off');


    % Save figure
    if options.save
        [~, name, ~] = fileparts(filenames(1));
        save_filename = fullfile('output', strcat(name, '_angle.png'));
        if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
        saveas(fig, save_filename, 'png');
    end
    