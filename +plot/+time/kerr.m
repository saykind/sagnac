function [fig, ax] = kerr(options)
%Plots kerr data from several files.
%   plot.kerr(Name, Value) specifies additional 
%   options with one or more Name, Value pair arguments. 
%
%   Output Arguments:
%   - fig           : Graphics handle.
%   - ax            : Axes handle.
%
%   Notes:
%   - The function util.logdata.lockin() is used to extract the lock-in data.
%   - The Kerr signal using util.math.kerr().
%   - The function the util.coarse.grain() is used for coarse-graining.
%   - The figure is saved in the 'output' directory.
%
%   See also plot.data();

arguments
    options.filenames string = [];
    options.ax = [];
    options.xlim double {mustBeNumeric} = NaN;
    options.ylim double {mustBeNumeric} = NaN;
    options.color string = [];
    options.time_shift double {mustBeNumeric} = 0;
    options.offset_range double {mustBeNumeric} = [0, 0];
    options.offset double {mustBeNumeric} = 0;
    options.x1_offset double {mustBeNumeric} = 0;
    options.dt double {mustBeNumeric} = 20;
    options.slope double {mustBeNumeric} = 0;   %urad/mT
    options.sls double {mustBeNumeric} = 0.25;
    options.coil_const double {mustBeNumeric} = 0;   % mT/A
    options.errorbar logical = true;
    options.default_display_names logical = true;
    options.show_legend logical = true;
    options.legends string = [];
    options.save logical = true;
    options.verbose logical = false;
end
    
    filenames = options.filenames;
    ax = options.ax;
    offset_range = options.offset_range;
    offsets = options.offset;
    x1_offsets = options.x1_offset;
    slope = options.slope;
    dt = options.dt;
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
        fig = figure('Name', 'Kerr Signal', ...
            'Units', 'centimeters', ...
            'Position', [0 0 20.5 12.9]);
        set(fig, 'PaperUnits', 'centimeters', 'PaperSize', [11 9]);
        ax = axes(fig);
    else
        fig = get(ax, 'Parent');
    end
    hold(ax, 'on'); 
    grid(ax, 'on');
    
    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        logdata = load(filename).logdata;
        offset = offsets(i);
        x1_offset = x1_offsets(i);
        
        % Extract data
        time = logdata.timer.time;
        if options.time_shift ~= 0
            time = time + options.time_shift;
        end
        if options.coil_const ~= 0
            curr = logdata.magnet.I;         % Magnet curr, A
            field = curr*options.coil_const; % Magnetic field, mT
        end
        [~, ~, ~, ~, ~, ~, kerr] = util.logdata.lockin(logdata.lockin, 'sls', options.sls, 'x1_offset', options.x1_offset);

        % Remove offset
        kerr_offset = 0;
        if offset_range(1) < offset_range(2)
            idx = temp > offset(1) & temp < offset(2);
            kerr_offset = mean(kerr(idx));
        end
        if offset ~= 0, kerr_offset = offset; end
        kerr = kerr - kerr_offset;

        if slope ~= 0
            kerr = kerr - slope*field;
        end

        % Coarse-grain
        [T, K, K2] = util.coarse.grain(dt, time, kerr);

        if plot_errorbar
            plt = errorbar(ax, T/60, K, K2, '.-', 'LineWidth', 1);
        else
            plt = plot(ax, T/60, K, '.-', 'LineWidth', 1);
        end
        if ~isempty(options.color), plt.Color = options.color; end 
        if options.default_display_names, plt.DisplayName = name; end
    end

    % Format plot
    if ~isnan(options.xlim), xlim(options.xlim); end
    if ~isnan(options.ylim), ylim(options.ylim); end
    ylabel(ax, '\DeltaKerr (\murad)');
    xlabel(ax, 'Times (min)');
    if options.show_legend, l = legend(ax, 'Location', 'best'); set(l, 'Interpreter', 'none'); end
    if ~isempty(legends), legend(ax, legends, 'Location', 'best'); end
    
    
    % Save figure
    if options.save
        [~, name, ~] = fileparts(filenames(1));
        save_filename = fullfile('output', strcat(name, '_time_kerr.png'));
        if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
        saveas(fig, save_filename, 'png');
    end
end
