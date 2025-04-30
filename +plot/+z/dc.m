function [fig, ax] = dc(options)
%DC plots dc data vs z.position
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
            xlabel = "Z position (um)", ...
            ylabel = "V_{DC} (mV)" ...
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

        % Coarse-grain
        [Z, V0] = util.coarse.sweep(logdata.sweep, z, v0);

        plot(ax, Z, V0, '.-', 'LineWidth', 1);
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