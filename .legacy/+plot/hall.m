function fig = hall(varargin)
    %Kerr data plot method
    %   Plots content of the logdata file.
    %   Arguments:
    %   - filename {''}
    %   - range {[-inf, inf]}
    %   - dT {1}
    %   - parametername {'parametername'}
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'range', [-inf, inf], @isnumeric);
    addParameter(p, 'fig', []);
    addParameter(p, 'axes', []);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    fig = parameters.fig;
    axes = parameters.axes;
    parametername = parameters.parametername;
    
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
    
    %% Graphics
    if isempty(axes)
        [fig, axes] = plt.hall_graphics(name, info.parametername);
    end
    ax1 = axes(1); ax2 = axes(2); 
    ax3 = axes(3); ax4 = axes(4);

    %% Data
    current = info.lockinA.amplitude/info.current_resistor; % Amp
    I = logdata.magnet.I;
    X = logdata.lockinA.X;
    Y = logdata.lockinA.Y;
    bX = logdata.lockinB.X;
    bY = logdata.lockinB.Y;
    
    R = logdata.lockinA.R;
    Q = logdata.lockinA.Q; %atan2d(Y, X);
    Rb = logdata.lockinB.R;
    Qb = logdata.lockinB.Q;

    
    yyaxis(ax1, 'left');
    plot(ax1, I, 1e3*X, 'LineWidth', 1.5, 'Color', 'r');
    
    yyaxis(ax1, 'right');
    plot(ax1, I, 1e3*Y, 'LineWidth', 1.5, 'Color', 'b');
    
    yyaxis(ax3, 'left');
    plot(ax3, I, 1e3*R, 'LineWidth', 1.5, 'Color', 'r');
    
    yyaxis(ax3, 'right');
    plot(ax3, I, Q, 'LineWidth', 1.5, 'Color', 'b')
    
    yyaxis(ax2, 'left');
    plot(ax2, I, 1e3*bX, 'LineWidth', 1.5, 'Color', 'r');
    
    yyaxis(ax2, 'right');
    plot(ax2, I, 1e3*bY, 'LineWidth', 1.5, 'Color', 'b');
    
    yyaxis(ax4, 'left');
    plot(ax4, I, 1e3*Rb, 'LineWidth', 1.5, 'Color', 'r');
    
    yyaxis(ax4, 'right');
    plot(ax4, I, Qb, 'LineWidth', 1.5, 'Color', 'b');
    
    saveas(fig, sprintf('output/%s.png', name), 'png');
end