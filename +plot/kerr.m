function fig = kerr(varargin)
    %Kerr data plot method
    %   Plots kerr data from several files.
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filenames', [], @isstring);
    addParameter(p, 'range', [-inf, inf], @isnumeric);
    addParameter(p, 'offset', [-inf, inf], @isnumeric);
    addParameter(p, 'dT', .4, @isnumeric);
    addParameter(p, 'legends', [], @isstring);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filenames = parameters.filenames;
    dT = parameters.dT;
    range = parameters.range;
    offset = parameters.offset;
    legends = parameters.legends;
    
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
    fig = figure('Name', 'Kerr Signal', ...
        'Units', 'centimeters', ...
        'Position', [0 0 27 10]);
    set(fig, 'PaperUnits', 'centimeters', 'PaperSize', [9 16]);
    ax = axes(fig);
    hold(ax, 'on'); 
    grid(ax, 'on');
    xlim(range);
    
    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        logdata = load(filename).logdata;
        temp = logdata.tempcont.A;
        
        V1X = logdata.lockin.X;
        sls = .25; %second harm lockin sensitivity
        V2 = sls*sqrt(logdata.lockin.AUX1.^2+logdata.lockin.AUX2.^2);
        c = besselj(2,1.841)/besselj(1,1.841);
        kerr = .5*atan(c*(V1X)./V2)*1e6; % Kerr signal, urad
        
        if offset(1) >= offset(2)
            kerr_offset = 0;
        else
            idx = temp > offset(1) & temp < offset(2);
            kerr_offset = mean(kerr(idx));
        end
        if ~isempty(legends)
            fprintf("%s: offset %.2d\n", legends(i), kerr_offset);
        end
        kerr = kerr - kerr_offset;
        [T, K, K2] = util.coarse_grain(dT, temp, kerr);
        errorbar(ax, T, K, K2, '.-', 'LineWidth', 1, 'DisplayName', name);
    end
    
    ylabel(ax, '\DeltaKerr (\murad)');
    xlabel(ax, 'Temperature (K)');
    if isempty(legends)
        l = legend(ax, 'Location', 'best');
    else
        l = legend(ax, legends);
    end
    set(l, 'Interpreter', 'none')
    
    [~, name, ~] = fileparts(filenames(1));
    saveas(fig, sprintf('output/%s_k.png', name), 'png');
end
    