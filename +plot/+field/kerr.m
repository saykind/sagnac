function [fig, ax, plt] = kerr(options)
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
    options.offset_range double {mustBeNumeric} = [0, 0];
    options.offset double {mustBeNumeric} = 0;
    options.scale double {mustBeNumeric} = 1;
    options.x1_offset double {mustBeNumeric} = 0;
    options.slope double {mustBeNumeric} = 0;   %urad/mT
    options.sls double {mustBeNumeric} = 0.25;
    options.coil_const double {mustBeNumeric} = 25;   % mT/A
    options.errorbar logical = true;
    options.linear_fit logical = false;
    options.interp logical = false;
    options.show_legend logical = true;
    options.legends string = [];
    options.color string = "#77AC30";
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
            'Position', [0 0 12 9]);
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
        curr = logdata.magnet.I;         % Magnet curr, A
        field = curr*options.coil_const; % Magnetic field, mT
        kerr = util.logdata.kerr(logdata.lockin, 'sls', sls, 'x1_offset', x1_offset);

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

        % Coarse-grain data
        n = numel(kerr);
        k = logdata.sweep.rate-logdata.sweep.pause;
        k = k(1);
        m = fix(n/k);
        KERR = mean(reshape(kerr, [k, m]),1);
        KERRstd = std(reshape(kerr, [k, m]),0,1);
        FIELD = mean(reshape(field, [k, m]),1); 
        KERR = KERR*options.scale;
        KERRstd = KERRstd*options.scale;    
        
        % Smooth data
        if options.interp
            IDX = 1:numel(FIELD);
            IDXq = linspace(IDX(1), IDX(end), 3e2);
            KERR = interp1(IDX, KERR, IDXq);
            FIELD = interp1(IDX, FIELD, IDXq);
        end
            

        % Plot
        if options.errorbar
            plt = errorbar(ax, FIELD, KERR, KERRstd, '.', ...
            'MarkerSize', 10, 'CapSize', 10, 'LineWidth', 2, 'DisplayName', name);
        else
            plt = plot(ax, FIELD, KERR, '.-', 'Color', options.color, ...
            'MarkerSize', 6, 'LineWidth', .5, 'DisplayName', name);
        end

        % Mark start and end points
        if options.mark_start_end
            plot(ax, FIELD(1), KERR(1), 'go', 'MarkerSize', 5, 'DisplayName', 'Start');
            plot(ax, FIELD(end), KERR(end), 'ro', 'MarkerSize', 5, 'DisplayName', 'End');
        end

        % Connect each data point with an arrows using quiver
        if options.arrows
            quiver(ax, FIELD(1:end-1), KERR(1:end-1), ...
                FIELD(2:end)-FIELD(1:end-1), KERR(2:end)-KERR(1:end-1), 0, ...
                'Color', 'black', 'MaxHeadSize', 0.02,'DisplayName', name);
        end

        % Linear fit
        if options.linear_fit
            [p, ~] = polyfit(FIELD, KERR, 1);
            field_linear = linspace(min(FIELD), max(FIELD), 100);
            kerr_linear = polyval(p, field_linear);
            disp_name = sprintf('%.3f urad/mT + %.2f urad', p(1), p(2));
            plot(ax, field_linear, kerr_linear, '--', 'LineWidth', 1, 'DisplayName', disp_name);
        end
    end
    
    % Format plot
    if ~isnan(options.ylim), ylim(options.ylim); end
    ylabel(ax, '\theta_K (\murad)');
    xlabel(ax, 'Magnetic Field (mT)');
    if options.show_legend
        l = legend(ax, 'Location', 'best'); 
        set(l, 'Interpreter', 'none'); 
    end
    if ~isempty(legends), legend(ax, legends, 'Location', 'best'); end
    
    % Save figure
    if options.save
        [~, name, ~] = fileparts(filenames(1));
        save_filename = fullfile('output', strcat(name, '_field_kerr.png'));
        if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
        saveas(fig, save_filename, 'png');
    end
end
    