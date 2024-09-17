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
    options.offset double {mustBeNumeric} = 0;
    options.x1_offset double {mustBeNumeric} = 0;
    options.dv double {mustBeNumeric} = 0;
    options.slope double {mustBeNumeric} = 0;   %urad*V
    options.sls double {mustBeNumeric} = 0.25;
    options.errorbar logical = false;
    options.linear_fit logical = false;
    options.default_display_names logical = false;
    options.show_legend logical = true;
    options.legends string = [];
    options.save logical = true;
    options.verbose logical = false;
end
    
    filenames = options.filenames;
    ax = options.ax;
    offsets = options.offset;
    x1_offsets = options.x1_offset;
    slope = options.slope;
    dv = options.dv;
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
        xlabel = "1/V_0 (V^{-1})", ...
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
        v0 = logdata.voltmeter.v1;
        kerr = util.logdata.kerr(logdata.lockin, 'sls', options.sls, 'x1_offset', x1_offset);

        % Remove offset
        kerr = kerr - offset;

        if slope ~= 0
            kerr = kerr - slope./v0;
        end

        % Coarse-grain
        [V0, K, K2] = util.coarse.grain(dv, v0, kerr);

        if plot_errorbar
            plt = errorbar(ax, 1./V0, K, K2, '.-', 'LineWidth', 1);
        else
            plt = plot(ax, 1./V0, K, '.-', 'LineWidth', 1);
        end
        if ~isempty(options.color), plt.Color = options.color; end 
        if options.default_display_names, plt.DisplayName = name; end

        if options.linear_fit
            [p, ~] = polyfit(1./V0, K, 1);
            x = linspace(min(1./V0), max(1./V0), 100);
            y = polyval(p, x);
            plot(ax, x, y, 'LineStyle', '--', 'LineWidth', 3, ...
             'DisplayName', sprintf('%.3f V^{-1} + %.2f', p(1), p(2)));
        end
    end

    % Format plot
    if ~isnan(options.xlim), xlim(options.xlim); end
    if ~isnan(options.ylim), ylim(options.ylim); end
    if options.show_legend, l = legend(ax, 'Location', 'best'); set(l, 'Interpreter', 'none'); end
    if ~isempty(legends), legend(ax, legends, 'Location', 'best'); end
    
    
    % Save figure
    if options.save
        [~, name, ~] = fileparts(filenames(1));
        save_filename = fullfile('output', strcat(name, '_dc_kerr.png'));
        if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
        saveas(fig, save_filename, 'png');
    end
end
