function fig = plot_transport(varargin)
    %Kerr data plot method
    %   Plots kerr data from several files.
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filenames', [], @isstring);
    addParameter(p, 'range', [-inf, inf], @isnumeric);
    addParameter(p, 'dT', .4, @isnumeric);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filenames = parameters.filenames;
    dT = parameters.dT;
    range = parameters.range;
    
    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = [];
        folder = 1;
        while folder ~= 0 
            [basefilename, folder] = uigetfile('*.mat', 'Select data file');
            filename = fullfile(folder, basefilename);
            filenames = [filenames, string(filename)];
        end
    end
    filenames(end) = [];
    
    % Create figure
    fig = figure('Name', 'Kerr Signal', ...
        'Units', 'centimeters', ...
        'Position', [0 0 10.5 12.9]);
    set(fig, 'PaperUnits', 'centimeters', 'PaperSize', [11 9]);
    ax = axes(fig);
    hold(ax, 'on'); 
    grid(ax, 'on');
    xlim(range);
    
    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        logdata = load(filename).logdata;
        temp = logdata.magnettemperature;
        x = 1e3*logdata.transportX;
        [T, X] = ...
            Utilities.coarse_grain(dT, temp, x);
        plot(ax, T, X, '.', 'LineWidth', 1.5, 'DisplayName', name);
    end
    
    ylabel(ax, 'Resistance (mOhms)');
    xlabel(ax, 'Temperature (K)');
    legend(ax);
    
    [~, name, ~] = fileparts(filenames(1));
    saveas(fig, sprintf('output/%s_t.png', name), 'png');
end
    