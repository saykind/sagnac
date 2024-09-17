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
%   See also plot.data(), plot.time.kerr();

arguments
    options.filenames string = [];
    options.ax = [];
    options.xlim double {mustBeNumeric} = [-inf, inf];
    options.ylim double {mustBeNumeric} = NaN;
    options.plot_options struct = struct();
    options.offset_range double {mustBeNumeric} = [0, 0];
    options.offset double {mustBeNumeric} = 0;
    options.x1_offset double {mustBeNumeric} = 0;
    options.dT double {mustBeNumeric} = 0.6;
    options.sls double {mustBeNumeric} = 0.25;
    options.errorbar logical = true;
    options.legends string = [];
    options.save logical = true;
    options.save_folder string = 'output';
    options.verbose logical = false;
end
    
    filenames = options.filenames;
    ax = options.ax;
    offset_range = options.offset_range;
    offsets = options.offset;
    x1_offsets = options.x1_offset;
    sls = options.sls;

    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = convertCharsToStrings(util.filename.select());
        options.filenames = filenames;
    end
    if isempty(filenames)
        util.msg('No file selected.');
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
    xlim(options.xlim);
    
    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        logdata = load(filename).logdata;
        offset = offsets(i);
        x1_offset = x1_offsets(i);

        % Extract data
        temp = logdata.tempcont.A;
        [x1, y1, x2, y2, r1, r2, kerr] = util.logdata.lockin(logdata.lockin, 'sls', sls, 'x1_offset', x1_offset);

        % Remove offset
        kerr_offset = 0;
        if offset_range(1) < offset_range(2)
            idx = temp > offset_range(1) & temp < offset_range(2);
            kerr_offset = mean(kerr(idx));
        end
        if offset ~= 0, kerr_offset = offset; end
        kerr = kerr - kerr_offset;

        % Coarse-grain
        [T, K, K2] = util.coarse.grain(options.dT, temp, kerr);

        % Plot
        if options.errorbar
            K2 = K2*3;
            errorbar(ax, T, K, K2, '.-', 'LineWidth', 1, 'DisplayName', name);
        else
            plot(ax, T, K, '.-', 'LineWidth', 1, 'DisplayName', name);
        end
    end
    
    % Format plot
    if ~isnan(options.ylim), ylim(options.ylim); end
    ylabel(ax, '\DeltaKerr (\murad)');
    xlabel(ax, 'Temperature (K)');
    if isempty(options.legends)
        l = legend(ax, 'Location', 'best');
    else
        l = legend(ax, options.legends);
    end
    set(l, 'Interpreter', 'none');

    
    % Save figure
    plot.save(fig, options);
end
    