function [fig, ax] = kerr(options)
%KERR plots kerr data from several files.
%   plot.kerr(Name, Value) specifies additional 
%   options with one or more Name, Value pair arguments. 
%
%   Output Arguments:
%   - fig           : Graphics handle.
%   - ax            : Axes handle.
%
%   Notes:
%   - The function util.logdata.lockin() is used to extract the lock-in data.
%   - The Kerr signal is calculated using util.math.kerr().
%   - The function the util.coarse.grain() is used for coarse-graining.
%   - The figure is saved in the 'output' directory.
%
%   See also plot.data();

    arguments
        options.filenames string = [];
        options.ax = [];
        options.xlim double {mustBeNumeric} = NaN;
        options.ylim double {mustBeNumeric} = NaN;
        options.offset double {mustBeNumeric} = 0;
        options.x1_offset double {mustBeNumeric} = 0;
        options.cutoff double {mustBeNumeric} = 10;
        options.dv double {mustBeNumeric} = 0;
        options.slope double {mustBeNumeric} = 0;   %urad*V
        options.errorbar logical = false;
        options.color = '';
        options.show_legend logical = false;
        options.legends string = [];
        options.save logical = true;
        options.verbose logical = false;
    end

    filenames = options.filenames;
    ax = options.ax;
    offsets = options.offset;
    x1_offsets = options.x1_offset;
    plot_errorbar = options.errorbar;
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

    % Fill in missing values for offsets
    n = numel(filenames);
    if numel(offsets) ~= n
        offsets = [offsets, repmat(offsets(end), 1, n - 1)];
    end
    if numel(x1_offsets) ~= n
        x1_offsets = [x1_offsets, repmat(x1_offsets(end), 1, n - 1)];
    end

    % Create figure
    if isempty(ax)
        [fig, ax] = plot.paper.graphics(...
            subplots = [1,1], ...
            xlabel = "Z position, um", ...
            ylabel = "\theta_K (\murad)" ...
            );
    else
        fig = get(ax, 'Parent');
    end

    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        logdata = load(filename).logdata;
        offset = offsets(i);
        x1_offset = x1_offsets(i);
        
        % Extract data
        z = 25.4*logdata.Z.position;    % Convert 0.001 inch to um 
        v0 = logdata.lockin.auxin0(:,1);
        kerr = util.logdata.kerr(logdata.lockin, 'x1_offset', x1_offset);

        % Remove offset
        kerr = kerr - offset;

        % Coarse-grain
        sweep = struct('rate', 40, 'pause', 0);
        [Z, V0, K] = util.coarse.sweep(sweep, z, v0, kerr);

        yyaxis(ax, 'left');
        ax.YAxis(1).Color = 'r';
        ylabel(ax, '\theta_K (\murad)');
        if ~isempty(options.color), c = options.color; else, c='r'; end            
        plot(ax, Z, K, '.-', 'LineWidth', 1, 'Color', c);
        yyaxis(ax, 'right');
        ax.YAxis(2).Color = 'm';
        ylabel(ax, 'V_{0} (mV)');
        plot(ax, Z, 1e3*V0, '--', 'LineWidth', 1, 'Color', 'm');
    end

    % Format plot
    if ~isnan(options.xlim), xlim(options.xlim); end
    if ~isnan(options.ylim), ylim(options.ylim); end
    if options.show_legend, l = legend(ax, 'Location', 'best'); set(l, 'Interpreter', 'none'); end
    if ~isempty(legends), legend(ax, legends, 'Location', 'best'); end
    
    % Save figure
    if options.save
        [~, name, ~] = fileparts(filenames(1));
        save_filename = fullfile('output', strcat(name, '_z_kerr.png'));
        if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
        saveas(fig, save_filename, 'png');
    end