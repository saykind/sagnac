function fig = plot_kerr(varargin)
    %Kerr data plot method
    %   Plots kerr data from several files.
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filenames', [], @isstring);
    addParameter(p, 'range', [-inf, inf], @isnumeric);
    addParameter(p, 'dT', .4, @isnumeric);
    addParameter(p, 'legend', [], @isstring);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filenames = parameters.filenames;
    dT = parameters.dT;
    range = parameters.range;
    legends = parameters.legend;
    
    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = [];
        folder = 1;
        while folder ~= 0 
            [basefilename, folder] = uigetfile('*.mat', 'Select data file');
            filename = fullfile(folder, basefilename);
            filenames = [filenames, string(filename)];
        end
        filenames(end) = [];
    end
    
    % Create figure
    fig = figure('Name', 'Transport', ...
        'Units', 'centimeters', ...
        'Position', [0 0 17 10]);
    set(fig, 'PaperUnits', 'centimeters', 'PaperSize', [9 16]);
    ax = axes(fig);
    hold(ax, 'on'); 
    grid(ax, 'on');
    xlim(range);
    
    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        logdata = load(filename).logdata;
        temp = logdata.sampletemperature;
        kerr = logdata.kerr;
        idx = temp > 5 & temp < 30;
        kerr_offset = mean(kerr(idx));
        kerr_offset = 0;
        if ~isempty(legends)
            fprintf("%s: offset %.2d\n", legends(i), kerr_offset);
        end
        kerr = kerr - kerr_offset;
        [T, K] = ...
            Utilities.coarse_grain(dT, temp, kerr);
        plot(ax, T, K, '.', 'LineWidth', 1.5, 'DisplayName', name);
    end
    
    ylabel(ax, 'Kerr (urad)');
    xlabel(ax, 'Temperature (K)');
    if isempty(legends)
        legend(ax);
    else
        legend(ax, legends);
    end
    
    [~, name, ~] = fileparts(filenames(1));
    saveas(fig, sprintf('output/%s_k.png', name), 'png');
end
    