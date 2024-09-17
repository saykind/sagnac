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
    options.parameter = 'timer.time';
    options.parameter_label string = 'Time (s)';
    options.filenames string = [];
    options.ax = [];
    options.xlim double {mustBeNumeric} = [-inf, inf];
    options.ylim double {mustBeNumeric} = NaN;
    options.offset_range double {mustBeNumeric} = [0, 0];
    options.offset double {mustBeNumeric} = 0;
    options.x1_offset double {mustBeNumeric} = 0;
    options.slope double {mustBeNumeric} = 0;   %urad/parameter_unit
    options.sls double {mustBeNumeric} = 0.25;
    options.errorbar logical = true;
    options.show_legend logical = true;
    options.legends string = [];
    options.mark_start_end logical = false;
    options.arrows logical = false;
    options.save logical = true;
    options.verbose logical = false;
end
    
    filenames = options.filenames;
    ax = options.ax;
    offset_range = options.offset_range;
    offsets = options.offset;
    x1_offsets = options.x1_offset;
    slope = options.slope;
    sls = options.sls;
    legends = options.legends;

    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = convertCharsToStrings(util.filename.select());
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
    xlim(options.xlim);
    
    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        logdata = load(filename).logdata;
        offset = offsets(i);
        x1_offset = x1_offsets(i);

        % Determine parameter
        % Split string by '.' and get the last element
        parameters = strsplit(options.parameter, '.');
        x = logdata;
        for j = 1:numel(parameters)
            disp(parameters(j));
            x = x.(parameters(j));
        end

        % Extract data
        [x1, ~, x2, y2] = util.logdata.lockin(logdata.lockin, 'sls', sls);
        if x1_offset ~= 0, x1 = x1 - x1_offset; end
        r2 = sqrt(x2.^2 + y2.^2);
        kerr = util.math.kerr(x1, r2);

        % Remove offset
        kerr_offset = 0;
        if offset_range(1) < offset_range(2)
            idx = x > offset(1) & x < offset(2);
            kerr_offset = mean(kerr(idx));
        end
        if offset ~= 0, kerr_offset = offset; end
        kerr = kerr - kerr_offset;

        if slope ~= 0
            kerr = kerr - slope*field;
        end

        % Coarse-grain data
        n = numel(kerr);
        k = logdata.sweep.rate-logdata.sweep.pause;
        k = k(1);
        m = fix(n/k);
        KERR = mean(reshape(kerr, [k, m]),1);
        KERRstd = std(reshape(kerr, [k, m]),0,1);
        X = mean(reshape(x, [k, m]),1);        

        % Plot
        if options.errorbar
            errorbar(ax, X, KERR, KERRstd, '.-', 'LineWidth', 1, 'DisplayName', name);
        else
            plot(ax, X, KERR, '.-', 'LineWidth', 1, 'DisplayName', name);
        end
    end
    
    % Format plot
    if ~isnan(options.ylim), ylim(options.ylim); end
    ylabel(ax, '\DeltaKerr (\murad)');
    xlabel(ax, options.parameter_label);
    if options.show_legend, l = legend(ax, 'Location', 'best'); set(l, 'Interpreter', 'none'); end
    if ~isempty(legends), legend(ax, legends, 'Location', 'best'); end
    
    % Save figure
    if options.save
        [~, name, ~] = fileparts(filenames(1));
        save_filename = fullfile('output', strcat(name, '_field_kerr.png'));
        if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
        saveas(fig, save_filename, 'png');
    end
end
    