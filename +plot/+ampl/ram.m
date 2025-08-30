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
        options.xlim double {mustBeNumeric} = NaN;
        options.proper double {mustBeNumeric} = NaN;
        options.show_legend logical = false;
        options.legends string = [];
        options.save logical = true;
        options.verbose logical = false;
    end

    filenames = options.filenames;
    legends = options.legends;
    verbose = options.verbose;

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
            title = "Modulation amplitude sweep", ...
            single_yticks = true, ...
            subplots = [3,1], ...
            xlabel = "Modulation Amplitude (V_{pk})" ...
            );
        % Format plot
        ylabel(ax(1), 'R_0 (mV)');
        ylabel(ax(2), 'R_1 (uV)');
        ylabel(ax(3), 'R_2 (mV)');
        if ~isnan(options.xlim), xlim(options.xlim); end
        set(ax(1), 'Clipping', 'off');
        set(ax(2), 'Clipping', 'off');
        set(ax(3), 'Clipping', 'off');
    else
        fig = options.fig;
        ax = fig.Children;
    end

    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        data = load(filename);
        logdata = data.logdata;
        
        % Extract data
        try
            ampl = logdata.lockin.output_amplitude(:,1);
        catch ME
            util.msg('No modulation amplitude information found.');
            return;
        end
        x1 = 1e6*logdata.lockin.x(:,1);
        y1 = 1e6*logdata.lockin.y(:,1);
        r1 = sqrt(x1.^2 + y1.^2);
        x2 = 1e3*logdata.lockin.x(:,2);
        y2 = 1e3*logdata.lockin.y(:,2);
        r2 = sqrt(x2.^2 + y2.^2);
        aux1 = 1e3*logdata.lockin.auxin0(:,1);


        % Coarse-grain
        try
            sweep = data.loginfo.sweep;
        catch ME
            util.msg('No sweep information found.');
            sweep = struct('rate', 10, 'pause', 6);
        end
        [A, R0, R1, R2] = util.coarse.sweep(sweep, ampl, aux1, r1, r2);

        %% R0 vs amplitude
        power = R0;
        x0 = [mean(power)/2, 1];
        F = @(x, A) x(1)*(besselj(0, 2*A*x(2))-1);
        x = lsqcurvefit(F, x0, A, power-power(1), [], [], optimset('Display', 'off'));
        power_ideal = power(1) + x(1)*(besselj(0, 2*A*x(2))-1);
        if verbose
            fprintf('R0: %.2f + %.2f (J0(2A*%.3f)-1)\n', power(1), x(1), x(2));
        end

        plot(ax(1), A, power, 'k.', 'MarkerSize', 4);
        plot(ax(1), A, power_ideal, 'b--', 'LineWidth', 1);

        %% R1 vs angle
        power = R1;
        R1_0 = power(1);
        F = @(x, A) R1_0 + x(1)*abs(besselj(1, 2*A*x(2)));
        x0 = [6*mean(power), 1];
        x = lsqcurvefit(F, x0, A, power, [], [], optimset('Display', 'off'));
        power_ideal = R1_0 + x(1)*abs(besselj(1, 2*A*x(2)));
        if verbose
            fprintf('R1: %.2f + %.2f J1(2A*%.3f)\n', R1_0, x(1), x(2));
        end

        plot(ax(2), A, power, 'k.', 'MarkerSize', 4);
        plot(ax(2), A, power_ideal, 'b--', 'LineWidth', 1);

        %% R2 vs angle
        power = R2;
        R2_0 = power(1);
        F = @(x, A) R2_0 + x(1)*abs(besselj(2, 2*A*x(2)));
        x0 = [6*mean(power), 1];
        x = lsqcurvefit(F, x0, A, power, [], [], optimset('Display', 'off'));
        power_ideal = R2_0 + x(1)*abs(besselj(2, 2*A*x(2)));
        if verbose
            fprintf('R2: %.2f + %.2f J2(2A*%.3f)\n', R2_0, x(1), x(2));
        end

        plot(ax(3), A, power, 'k.', 'MarkerSize', 4);
        plot(ax(3), A, power_ideal, 'b--', 'LineWidth', 1);
    end

    if ~isnan(options.proper)
        % add vertical red dashed line to all plots
        for j = 1:numel(ax)
            xline(ax(j), options.proper, 'r--', 'LineWidth', 1);
        end
    end

    % Save figure
    if options.save
        [~, name, ~] = fileparts(filenames(1));
        save_filename = fullfile('output', strcat(name, '_angle.png'));
        if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
        saveas(fig, save_filename, 'png');
    end
    