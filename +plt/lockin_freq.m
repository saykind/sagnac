function axes = lockin_freq(varargin)
    %Kerr data plot method
    %   Plots content of the logdata file.
    %   Arguments:
    %   - filename {''}
    %   - axes {NaN}
    %   - range {[-inf, inf]}
    %   - dT {1}
    %   - parametername {'Parameter'}
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'axes', []);
    addParameter(p, 'draft', nan, @isnumeric);
    addParameter(p, 'range', [-inf, inf], @isnumeric);
    addParameter(p, 'dT', 0, @isnumeric);
    addParameter(p, 'parametername', 'Parameter', @ischar);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    axes = parameters.axes;
    draft = parameters.draft;
    dT = parameters.dT;
    range = parameters.range;
    parametername = parameters.parametername;
    [~, name, ~] = fileparts(filename);
    
    %% Configure Figure
    if isempty(axes)
        fig = figure('Name', name, ...
            'Units', 'centimeters', ...
            'Position', [0 0 20.5 12.9]);
        set(fig, 'PaperUnits', 'centimeters', 'PaperSize', [11 9]);
        t = tiledlayout(fig, 2, 1);
        ax1 = nexttile(t); ax2 = nexttile(t);
        axes = [ax1, ax2];
        if ~isnan(draft)
            return
        end
    else
        ax1 = axes(1);
        ax2 = axes(2);
        hold(ax1, 'off');
        hold(ax2, 'off');
    end
    hold(ax1, 'on'); grid(ax1, 'on'); box(ax1, 'on');
    hold(ax2, 'on'); grid(ax2, 'on'); box(ax2, 'on');
    
    %% Data
    % If no filename is given, open file browser
    if isempty(filename) 
        [basefilename, folder] = uigetfile('*.mat', 'Select data file');
        filename = fullfile(folder, basefilename);
        if basefilename == 0
            disp('Please supply logdata structure or path to datafile.');
            return;
        end
    end
    [~, name, ~] = fileparts(filename);
    data = load(filename);
    logdata = data.logdata;
    info = data.info;
    current = 1;
    if isfield(data, 'info')
        current = info.lockin.amplitude/info.current_resistor;
        if isfield(data.info, 'parametername')
            parametername = info.parametername;
        end
    end
    
    f = logdata.lockin.f;
    X = logdata.lockin.X/current;
    Y = logdata.lockin.Y/current;
    R = logdata.lockin.R/current;
    Q = logdata.lockin.Q;
    
    %% Plot
    
    if isfield(info, 'title')
        title(ax1, info.title);
    end
    cla(ax1);
    cla(ax2);
    
    yyaxis(ax1, 'left');
    set(ax1, 'YColor', 'r');
    plot(ax1, f, X, '-', 'LineWidth', 1.5, 'Color', 'r');
    ylabel(ax1, 'Re V/I, Ohms');
    
    yyaxis(ax1, 'right');
    set(ax1, 'YColor', 'b');
    plot(ax1, f, Y, '-', 'LineWidth', 1.5, 'Color', 'b');
    ylabel(ax1, 'Im V/I, Ohms');
    
    yyaxis(ax2, 'left');
    set(ax2, 'YColor', 'r');
    plot(ax2, f, R, '-', 'LineWidth', 1.5, 'Color', 'r');
    ylabel(ax2, 'Mag V/I, Ohms');
    
    yyaxis(ax2, 'right');
    set(ax2, 'YColor', 'b');
    plot(ax2, f, Q, '-', 'LineWidth', 1.5, 'Color', 'b');
    ylabel(ax2, 'Phase V, deg');
    
    xlabel(ax2, parametername);
    
    saveas(gcf, sprintf('output/%s.png', name), 'png');
end