function fig = kerr(varargin)
%Plots kerr data from several files.
%   plot.kerr(Name, Value) specifies additional 
%   options with one or more Name, Value pair arguments. 
% 
%   Name-Value Pair Arguments:
%   - 'filenames'   : default []
%                   : filename to load.
%                     When filenames is empty, file browser open,
%                     It continues to reopen after file is selected,
%                     to allow multiple file selction.
%   - 'range'       : default [-inf,inf] 
%                   : Temperature range to plot (uses logdata.tempcont.A).
%   - 'offset'      : default [-inf,inf] 
%                   : Temperature range to calculte kerr offset.
%                     kerr := kerr - mean(kerr(T in offset)).
%   - 'dT'          : default 0.4
%                   : Scalar specifying the temperature interval for 
%                     coarse-graining the data.
%   - 'sls'         : default 0.25
%                   : Scalar specifying the second harmonic lockin
%                     sensitivity in Volts.
%   - 'legend'      : default []
%                   : String array of legends for each dataset. 
%                     If empty or not provided, the file names 
%                     will be used as legends.
%
%   Output Arguments:
%   - fig           : Graphics handle.
%
%   Example:
%   plot.kerr();
%   plot.kerr('range', [10, 30], 'dT', 0.4, 'offset', [25, 30]);
%
%   Notes:
%   - The function requires that the .mat files contain a 'logdata' 
%     structure with fields:
%       'tempcont.A',
%       'lockin.X',
%       'lockin.AUX1',
%       'lockin.AUX2'.
%   - The Kerr signal is calculated using the formula:
%     Kerr = 0.5 * atan(c * (V1X) ./ V2) * 1e6 (in microradians),
%     where c is a constant calculated using Bessel functions.
%   - The function uses the 'util.coarse_grain' function for coarse-graining.
%   - The figure is saved in the 'output' directory with the name format:
%     <first_filename>_k.png.
%
%   See also plot.data();
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filenames', [], @isstring);
    addParameter(p, 'range', [-inf, inf], @isnumeric);
    addParameter(p, 'offset', [-inf, inf], @isnumeric);
    addParameter(p, 'dT', .4, @isnumeric);
    addParameter(p, 'sls', .25, @isnumeric);
    addParameter(p, 'legends', [], @isstring);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filenames = parameters.filenames;
    range = parameters.range;
    offset = parameters.offset;
    dT = parameters.dT;
    sls = parameters.sls;
    legends = parameters.legends;

    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = convertCharsToStrings(util.filename.select());
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
        V2 = sls*sqrt(logdata.lockin.AUX1.^2+logdata.lockin.AUX2.^2);
        kerr = util.math.kerr(V1X, V2);

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
        [T, K, K2] = util.coarse.grain(dT, temp, kerr);
        errorbar(ax, T, K, K2, '.-', 'LineWidth', 1, 'DisplayName', name);
    end
    
    ylabel(ax, '\DeltaKerr (\murad)');
    xlabel(ax, 'Temperature (K)');
    if isempty(legends)
        l = legend(ax, 'Location', 'best');
    else
        l = legend(ax, legends);
    end
    set(l, 'Interpreter', 'none');
    
    [~, name, ~] = fileparts(filenames(1));
    saveas(fig, sprintf('output/%s_k.png', name), 'png');
end
    