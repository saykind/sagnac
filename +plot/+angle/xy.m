function [fig, ax] = xy(options)
%XY plots rotated waveplate data from several files.
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
        logdata = load(filename).logdata;
        
        % Extract data
        angle = logdata.waveplate.angle;
        vx = logdata.lockin.auxin0;
        vy = logdata.lockin.auxin1;

        % Scale data
        vx = vx * options.scale;
        vy = vy * options.scale;

        % Coarse-grain
        sweep = struct('rate', 20, 'pause', 0);
        [A, Vx, Vy] = util.coarse.sweep(sweep, angle, vx, vy);

        % Ideal fit curves
        a = linspace(A(1), A(end), 1000);
        % Single polarizer
        Vx_ideal = .5*sind(2*(a - A(1))).^2;
        Vy_ideal = .5*cosd(2*(a - A(1))).^2;

        yyaxis(ax, 'left');
        plot(ax, A, Vx, 'r.-', 'MarkerSize', 10, 'DisplayName', 'P_x');
        plot(ax, a, Vx_ideal, 'r--', 'LineWidth', 1, 'DisplayName', 'P_x ideal');

        yyaxis(ax, 'right');
        plot(ax, A, Vy, 'b.-', 'MarkerSize', 10, 'DisplayName', 'P_y');
        plot(ax, a, Vy_ideal, 'b--', 'LineWidth', 1, 'DisplayName', 'P_y ideal');
    end

    % Format plot
    yyaxis(ax, 'left');
    ax.YAxis(1).Color = 'r';
    ylabel(ax, 'P_{x} (V)');
    if ~isnan(options.ylim), ylim(options.ylim); end

    yyaxis(ax, 'right');
    ax.YAxis(2).Color = 'b';
    ylabel(ax, 'P_{y} (V)');
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
    