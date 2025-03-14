function [fig, ax] = kerr(options)
%Plots kerr data from signle datafile containing xy scan.
%   plot.xy.kerr(Name, Value) specifies additional 
%   options with one or more Name, Value pair arguments. 
% 
%   Name-Value Pair Arguments:
%   - 'filenames'   : default []
%                   : filename to load.
%                     When filenames is empty, file browser open.
%   - 'sls'         : default 0.25
%                   : Scalar specifying the second harmonic lockin
%                     sensitivity in Volts.
%   - 'offset'      : default 0 (urad)
%                   : Scalar specifying the offset in the Kerr signal.
%   - 'cutoff'      : default 0 (Volts)
%                   : Scalar specifying the dc voltage V0 cutoff in Volts.
%                     Data points with V0 < cutoff are ignored.
%   - 'clim'        : default []
%                   : 2-element vector specifying the color limits.
%   - 'surf'        : default false
%                   : Logical specifying whether to make a surface plot or image.
%   - 'axis'        : default true
%                   : Logical specifying whether to show the axis.
%   - 'interpolate' : default 2
%                   : Scalar specifying the interpolation factor.
%   - 'histogram'   : default false
%                   : Logical specifying whether to plot a histogram of the
%                     Kerr signal.
%   - 'legend'      : default []
%                   : String array of legends for each dataset. 
%                     If empty or not provided, the file names 
%                     will be used as legends.
%   - 'save'        : default true
%                   : Logical specifying whether to save the figure.
%
%   Output Arguments:
%   - fig           : Graphics handle.
%
%   Example:
%   plot.xy.kerr();
%   plot.xy.kerr('range', [10, 30], 'dT', 0.4, 'offset', [25, 30]);
%
%   Notes:
%   - The function requires that the .mat files contain a 'logdata' 
%     structure with fields:
%       'sweep',
%       'voltmeter',
%       'lockin',
%   - The Kerr signal is calculated using the formula:
%     Kerr = 0.5 * atan(c * (V1X) ./ V2) * 1e6 (in microradians),
%     where c is a constant calculated using Bessel functions.
%   - The function uses the 'util.coarse.grain' function for coarse-graining.
%   - The figure is saved in the 'output' directory with the name format:
%     <first_filename>_k.png.
%
%   See also plot.temp.kerr();

    arguments
        options.filenames string = [];
        options.sls double {mustBeNumeric} = .25;
        options.offsets double {mustBeNumeric} = 0;
        options.cutoffs double {mustBeNumeric} = 50;
        options.slope double {mustBeNumeric} = 0;
        options.x0 double {mustBeNumeric} = 0;
        options.y0 double {mustBeNumeric} = 0;
        options.xlim double {mustBeNumeric} = [];
        options.ylim double {mustBeNumeric} = [];
        options.clim double {mustBeNumeric} = [];
        options.surf logical = false;
        options.ax = [];
        options.axis logical = true;
        options.interpolate double {mustBeNumeric} = 2;
        options.histogram logical = false;
        options.save logical = true;
    end
    
    %% Parse options
    filenames = options.filenames;
    offsets = options.offsets;
    cutoffs = options.cutoffs;
    interp_factor = options.interpolate;
    ax = options.ax;

    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = convertCharsToStrings(util.filename.select());
    end
    if isempty(filenames)
        util.msg("No file selected.");
        return
    end

    % Fill in missing values for offsets
    n = numel(filenames);
    if numel(offsets) ~= n
        offsets = [offsets, repmat(offsets(end), 1, n - 1)];
    end

    for i = 1:numel(filenames)
        filename = filenames(i);
        offset = offsets(i);
        cutoff = cutoffs(i);
    
        %% Load data
        logdata = load(filename).logdata;

        % Check if the data is a xy scan
        if ~isfield(logdata.sweep, 'range')
            error("The data does not contain a xy scan.");
        end

        % x, y data
        shape_xy = logdata.sweep.shape;                     % shape of the scan [x_points, y_points]
        x = 1e3*logdata.sweep.range(1,:);                   % x-axis in um
        y = 1e3*logdata.sweep.range(2,:);                   % y-axis in um
        if isfield(logdata.sweep, 'origin')
            x = x - 1e3*logdata.sweep.origin(1);
            y = y - 1e3*logdata.sweep.origin(2);
        end
        if ~isempty(options.x0)
            x = x - options.x0;
        end
        if ~isempty(options.y0)
            y = y - options.y0;
        end
        X = util.mesh.combine(x, shape_xy);
        Y = util.mesh.combine(y, shape_xy);
        n_xypoints = length(logdata.sweep.range);
        
        % extract logdata
        v0 = 1e3*logdata.voltmeter.v1;                          % DC voltage in mV
        kerr = util.logdata.kerr(logdata.lockin);

        n_datapoint = numel(kerr);                          % total number of raw datapoints
        n_wait = logdata.sweep.rate-logdata.sweep.pause;    % number of raw datapoints to average into one datapoint
        n_position = fix(n_datapoint/n_wait);               % number of different positions in the scan
        if n_position < n_xypoints
            fprintf("Number of datapositions (%d) is less than the number of xy points (%d).\n", n_position, n_xypoints);
            fprintf("Filling the rest of the data with last value...\n");
            kerr = [kerr; repmat(kerr(n_position), 1, n_wait*(n_xypoints-n_position))'];
            v0 = [v0; repmat(v0(n_position), 1, n_wait*(n_xypoints-n_position))'];
            n_position = n_xypoints;
        end
        shape_avg = [n_wait, n_position];                   % shape to use for averaging
        kerr = mean(reshape(kerr, shape_avg), 1);
        v0 = mean(reshape(v0, shape_avg), 1);

        % Substract kerr offsets
        if offset ~= 0
            kerr = kerr - offset;
        end

        % Substract kerr vs DC dependence
        if options.slope ~= 0
            kerr = kerr - 1e3*options.slope./v0;
        end

        V0 = util.mesh.combine(v0, shape_xy);
        KERR = util.mesh.combine(kerr, shape_xy);

        %% Plot data
        %% Ignore data points with V0 < cutoff
        if cutoff > 0
            mask = V0 < cutoff;
            KERR(mask) = NaN;
        end

        % Plot histogram
        if options.histogram
            plot_kerr_histogram(KERR, V0);
        end

        % Interpolate data
        if interp_factor > 1
            x = X(1,:);
            y = Y(:,1);
            xq = linspace(min(x), max(x), (length(x)-1)*interp_factor+1);
            yq = linspace(min(y), max(y), (length(y)-1)*interp_factor+1);
            [Xq, Yq] = meshgrid(xq, yq);
            KERR = interp2(X, Y, KERR, Xq, Yq, 'spline');
            V0 = interp2(X, Y, V0, Xq, Yq, 'spline');
            x = xq;
            y = yq;
            X = Xq;
            Y = Yq;
        end


        %% Plot kerr data
        if options.surf
            [fig, ax] = plot_kerr_surf(X, Y, KERR);
        else
            [fig, ax] = plot_kerr_image(X, Y, KERR, ax);
        end
        if ~options.axis
            axis(ax, 'off');
        end

        if ~isempty(options.clim)
            % check matlab version
            if isMATLABReleaseOlderThan('R2021a')
                caxis(ax, options.clim); %#ok<CAXIS>
            else
                clim(ax, options.clim);
            end
        end

        if ~isempty(options.xlim)
            xlim(ax, options.xlim);
        end
        if ~isempty(options.ylim)
            ylim(ax, options.ylim);
        end
        
        %% Save plot
        if options.save
            [~, name, ~] = fileparts(filename);
            if ~exist('output', 'dir'), mkdir('output'); end
            saveas(fig, sprintf('output/%s_xy.png', name), 'png');
        end

    end

end

function [fig, ax] = plot_kerr_surf(X, Y, KERR)
    fig = figure('Name', 'Kerr Signal', ...
        'Units', 'centimeters', ...
        'Position', [0 0 16 14]); % [x y width height]
    set(fig, 'PaperUnits', 'centimeters', 'PaperSize', [16 16]); % [width height]
    ax = axes(fig);
    hold(ax, 'on'); 
    grid(ax, 'on');
    set(ax, 'FontSize', 12, 'FontName', 'Arial');
    %set(ax, 'DataAspectRatio', [1 1 1]);
    xlabel(ax, "X, \mum");
    ylabel(ax, "Y, \mum");
    title(ax, "Magnetism");
    cb = colorbar(ax);
    cb.Label.String = "\theta, \murad";
    cb.Label.Rotation = 270;
    cb.Label.FontSize = 12;
    cb.Label.VerticalAlignment = "bottom";
    colormap(ax, jet);

    %% Plot kerr signal
    axis(ax, 'tight');
    surf(ax, X, Y, KERR, 'EdgeAlpha', .1);
end

function [fig, ax] = plot_kerr_image(X, Y, KERR, ax)
    if isempty(ax)
        fig = figure('Name', 'Kerr Signal', ...
            'Units', 'centimeters', ...
            'Position', [0 0 16 14]); % [x y width height]
        set(fig, 'PaperUnits', 'centimeters', 'PaperSize', [16 16]); % [width height]
        ax = axes(fig);
        hold(ax, 'on'); 
        grid(ax, 'on');
        set(ax, 'FontSize', 12, 'FontName', 'Arial');
        set(ax, 'DataAspectRatio', [1 1 1]);
        xlabel(ax, "X, \mum");
        ylabel(ax, "Y, \mum");
        title(ax, "Magnetism");
        cb = colorbar(ax);
        cb.Label.String = "\theta, \murad";
        cb.Label.Rotation = 270;
        cb.Label.FontSize = 12;
        cb.Label.VerticalAlignment = "bottom";
        colormap(ax, jet);
    else
        fig = get(ax, 'Parent');
    end

    %% Plot kerr signal
    axis(ax, 'tight');
    imagesc(ax, X(1,:), Y(:,1), KERR);
end

function [fig, ax] = plot_kerr_histogram(KERR, V0)
    fig = figure('Name', 'Kerr Signal Histogram', ...
        'Units', 'centimeters', ...
        'Position', [0 0 16 24]); % [x y width height]
    set(fig, 'PaperUnits', 'centimeters', 'PaperSize', [16 16]); % [width height]
    tl = tiledlayout(fig, 2, 1);
    axisA = nexttile(tl);
    axisB = nexttile(tl);
    for ax = [axisA, axisB]
        hold(ax, 'on');
        grid(ax, 'on');
        set(ax, 'FontSize', 12, 'FontName', 'Arial');
        xlabel(ax, "Kerr Signal, \murad");
    end
    ylabel(axisA, "Counts");
    ylabel(axisB, "DC Voltage, mV");
    title(axisA, "Kerr Signal vs DC Voltage");

    histogram(axisA, KERR(:), 'DisplayStyle', 'stairs', 'LineWidth', 1);
    histogram(axisA, KERR(:), 'DisplayStyle', 'bar', 'EdgeColor', 'none');
    plot(axisB, KERR, V0, '.');
end