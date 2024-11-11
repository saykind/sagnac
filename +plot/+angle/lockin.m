function [fig, ax] = lockin(options)
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
        options.ax = [];
        options.scale double {mustBeNumeric} = 1;
        options.xlim double {mustBeNumeric} = NaN;
        options.ylim double {mustBeNumeric} = NaN;
        options.show_legend logical = false;
        options.legends string = [];
        options.save logical = true;
        options.verbose logical = false;
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
    if isempty(ax)
        [fig, ax] = plot.paper.graphics(...
            subplots = [1,1], ...
            xlabel = "HWP angle (deg)" ...
            );
    else
        fig = get(ax, 'Parent');
    end

    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        data = load(filename);
        logdata = data.logdata;
        loginfo = data.loginfo;
        
        % Extract data
        angle = logdata.waveplate.angle;
        [x1, y1, x2, y2, r1, r2] = util.logdata.lockin(logdata.lockin);
        aux1 = logdata.lockin.auxin0(:,1);
        aux2 = logdata.lockin.auxin1(:,1);

        % normalize
        dc = mean(aux1);
        %x1 = x1/dc;
        %y1 = y1/dc;
        %x2 = x2/dc;
        %y2 = y2/dc;

        % Coarse-grain
        sweep = struct('rate', 16, 'pause', 8);
        [A, X1, Y1, X2, Y2, R1, R2] = util.coarse.sweep(sweep, angle, x1, y1, x2, y2, r1, r2);
        %A = A(1:end-1);
        %X1 = X1(1:end-1);
        %Y1 = Y1(1:end-1);
        %X2 = X2(1:end-1);
        %Y2 = Y2(1:end-1);
        %R1 = R1(1:end-1);
        %R2 = R2(1:end-1);

        % Fourier
        power = X2;
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
            fprintf("F0 = %6.4f.\n", F0);
            fprintf("F1s = %6.4f.\n", F1s);
            fprintf("F1c = %6.4f.\n", F1c);
            fprintf("F2s = %6.4f.\n", F2s);
            fprintf("F2c = %6.4f.\n", F2c);
            fprintf("F4s = %6.4f.\n", F4s);
            fprintf("F4c = %6.4f.\n", F4c);
            fprintf("F6s = %6.4f.\n", F6s);
            fprintf("F6c = %6.4f.\n", F6c);
        end

        % Fourier fit
        x0 = [F0, F1c, F1s, F2c, F2s, F4c, F4s, F6c, F6s];
        F = @(x, angle) x(1) ...
            + x(2)*cosd(angle)   + x(3)*sind(angle) ...
            + x(4)*cosd(2*angle) + x(5)*sind(2*angle) ...
            + x(6)*cosd(4*angle) + x(7)*sind(4*angle) ...
            + x(8)*cosd(6*angle) + x(9)*sind(6*angle);
        x = lsqcurvefit(F, x0, A, power, [], [], optimset('Display', 'off'));
        F0 = x(1);
        F1c = x(2);
        F1s = x(3);
        F2c = x(4);
        F2s = x(5);
        F4c = x(6);
        F4s = x(7);
        F6c = x(8);
        F6s = x(9);
        power_ideal = F0 + F1c*cosd(A) + F1s*sind(A) + F2c*cosd(2*A) + F2s*sind(2*A) + F4c*cosd(4*A) + F4s*sind(4*A) + F6c*cosd(6*A) + F6s*sind(6*A);
        % Display Fourier coefficients
        if verbose
            fprintf("F0 = %6.4f.\n", F0);
            fprintf("F1s = %6.4f.\n", F1s);
            fprintf("F1c = %6.4f.\n", F1c);
            fprintf("F2s = %6.4f.\n", F2s);
            fprintf("F2c = %6.4f.\n", F2c);
            fprintf("F4s = %6.4f.\n", F4s);
            fprintf("F4c = %6.4f.\n", F4c);
            fprintf("F6s = %6.4f.\n", F6s);
            fprintf("F6c = %6.4f.\n", F6c);
        end

        yyaxis(ax, 'left');
        plot(ax, A, X2, 'r.', 'MarkerSize', 8);
        plot(ax, A, power_ideal, 'r--', 'LineWidth', 1);

        yyaxis(ax, 'right');
        plot(ax, A, Y2, 'b.', 'MarkerSize', 5);
    end

    % Format plot
    yyaxis(ax, 'left');
    ax.YAxis(1).Color = 'r';
    ylabel(ax, 'X_2/V_{DC}');
    if ~isnan(options.ylim), ylim(options.ylim); end

    yyaxis(ax, 'right');
    ax.YAxis(2).Color = 'b';
    ylabel(ax, 'Y_2/V_{DC}');
    if ~isnan(options.ylim), ylim(options.ylim); end    

    if ~isnan(options.xlim), xlim(options.xlim); end
    if options.show_legend, l = legend(ax, 'Location', 'best'); set(l, 'Interpreter', 'none'); end
    if ~isempty(legends), legend(ax, legends, 'Location', 'best'); end
    set(ax, 'Clipping', 'off');


    % Save figure
    if options.save
        [~, name, ~] = fileparts(filenames(1));
        save_filename = fullfile('output', strcat(name, '_angle.png'));
        if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
        saveas(fig, save_filename, 'png');
    end
    