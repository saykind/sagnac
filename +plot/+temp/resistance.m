function [fig, ax, plot_handle] = resistance(options)
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

arguments
    options.filenames string = [];
    options.ax = [];
    options.xlim double {mustBeNumeric} = [-inf, inf];
    options.ylim double {mustBeNumeric} = NaN;
    options.plot_options struct = struct();
    options.dT double {mustBeNumeric} = 0.6;
    options.derivative logical = false;
    options.current double {mustBeNumeric} = .1;
    options.legends string = [];    
    options.ylabel string = 'Resistance (\Omega)';
    options.color string = [];
    options.save logical = true;
    options.save_folder string = 'output';
    options.verbose logical = false;
end

    filenames = options.filenames;
    ax = options.ax;
    curr = options.current;

    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = convertCharsToStrings(util.filename.select());
        options.filenames = filenames;
    end
    if isempty(filenames)
        util.msg('No file selected.');
        return;
    end

    % Current (Voltage/resistance coefficient)
    if options.verbose
        disp('Current: ' + string(curr) + ' A');
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
    ylabel(ax, options.ylabel);
    xlabel(ax, 'Temperature (K)');

    %%% Plot data
    for i = 1:length(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);

        logdata = load(filename).logdata;
        t = logdata.tempcont.B;
        r = logdata.lockinB.X./logdata.lockinA.X;
        q = atan2d(logdata.lockinB.Y, logdata.lockinB.X);

        % Plot data
        if options.derivative
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

        yyaxis(ax, 'left');
        ax.YColor = 'r';
        plot_handle = plot(ax, t, r, 'r', 'DisplayName', name);
        yyaxis(ax, 'right');
        ax.YColor = 'b';
        plot(ax, t, q, 'b');
        ylabel(ax, 'Phase (deg)');

        if ~isempty(options.color), plot_handle.Color = options.color; end
    end

    % Legend
    if ~isempty(options.legends)
        legend(ax, options.legends, 'Location', 'best');
    end

end




