function resistance(varargin)
%Plots resistance data from files.
%   resistance(...) plots resistance data from files specified by
%   filepaths. filepaths is a cell array of strings containing the
%   absolute or relative paths to the files. 
%
%   Name-value pairs:
%       'filenames' - String array of the filenames.
%                     Default is [].
%                     If 'filenames' is empty, file browser is opened.
%       'foldername' - String of the folder name containing the files.
%                      Default is "".
%       'current' - Specifies the current used to calculate resistance.
%                   Default is .1 A.
%
%   Example:
%       filenames = ["2019-08-07_1.mat", "2019-08-07_2.mat"];
%       plot.resistance('filenames', filenames, 'foldername', "data");
%
%   Notes:
%   - The function requires that the .mat files contain a 'logdata' 
%     structure with fields:
%       - tempcont.A - Temperature data.
%       - lockinA.X - Resistance data.
%


    %%% Parse input
    p = inputParser;
    addParameter(p, 'filenames', [], @isstring);
    addParameter(p, 'foldername', "", @isstring);
    addParameter(p, 'current', .1, @isnumeric);
    addParameter(p, 'derivative', false, @islogical);
    addParameter(p, 'verbose', false, @islogical);
    parse(p, varargin{:});
    parameters = p.Results;
    filenames = parameters.filenames;
    foldername = parameters.foldername;
    curr = parameters.current;

    % If no filename is given, open file browser
    if isempty(filenames)
        [files, foldername] = uigetfile('*.mat', 'Select data files', 'MultiSelect', 'on');
        if foldername == 0  % User clicked "Cancel"
            return;
        end
        if ischar(files)  % Single file selected
            files = {files};
        end
        filenames = fullfile(foldername, files);
    else
        % If foldername is given, add it to filenames
        if ~isempty(foldername)
            filenames = fullfile(foldername, filenames);
        end
    end
    filenames = string(filenames);

    % Current (Voltage/resistance coefficient)
    if parameters.verbose
        disp('Current: ' + string(curr) + ' A');
    end

    %%% Make figure
    fig = figure('Name', 'Resistance', ...
        'Units', 'centimeters', ...
        'Position', [0 0 27 10]);
    set(fig, 'PaperUnits', 'centimeters', 'PaperSize', [9 16]);
    ax = axes(fig);
    hold(ax, 'on'); 
    grid(ax, 'on');
    xlabel('Temperature (K)');
    ylabel('Resistance (\Omega)');
    title('Resistance vs Temperature');

    %%% Plot data
    for i = 1:length(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);

        logdata = load(filename).logdata;
        t = logdata.tempcont.A;
        r = logdata.lockinA.X/curr;

        % Plot data
        if parameters.derivative
            % coarse grain
            [t, r] = util.coarse.grain(.5, t, r);
            % spline interpolation
            t_new = linspace(t(1), t(end), 1000);
            r = spline(t, r, t_new);
            t = t_new;
            % derivative
            r = diff(r)./diff(t);
            t = t(1:end-1);
        end
        plot(ax, t, r, 'DisplayName', name);
    end

    % Add legend
    % FIXME Turn off latex interpreter for legend
    lgd = legend('Location', 'best');
    lgd.Interpreter = 'none';

    % Hold off for further plotting
    hold off;

end




