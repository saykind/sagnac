function [fig, ax] = rmcd(options)
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
    options.plot_options struct = struct();
    options.offset_range double {mustBeNumeric} = [0, 0];
    options.offset double {mustBeNumeric} = 0;
    options.x1_offset double {mustBeNumeric} = 0;
    options.y1_offset double {mustBeNumeric} = 0;
    options.phase_offset double {mustBeNumeric} = 0;
    options.A double {mustBeNumeric} = 34.3;  %38.9; RMCD amplitude/DC
    options.dT double {mustBeNumeric} = 0.6;
    options.errorbar logical = true;
    options.legends string = [];
    options.save logical = false;
    options.verbose logical = true;
end
    
    filenames = options.filenames;
    ax = options.ax;
    offset_range = options.offset_range;
    offsets = options.offset;
    x1_offsets = options.x1_offset;
    y1_offsets = options.y1_offset;
    A = options.A;

    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = convertCharsToStrings(util.filename.select());
    end
    if isempty(filenames)
        warning('No file selected.');
        return;
    end
    %reverse filenames
    %filenames = filenames(end:-1:1);

    % Fill in missing values for offsets (multiple files)
    n = numel(filenames);
    if numel(offsets) ~= n
        offsets = [offsets, repmat(offsets(end), 1, n - 1)];
    end
    if numel(x1_offsets) ~= n
        x1_offsets = [x1_offsets, repmat(x1_offsets(end), 1, n - 1)];
    end
    if numel(y1_offsets) ~= n
        y1_offsets = [y1_offsets, repmat(y1_offsets(end), 1, n - 1)];
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
    
    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        logdata = load(filename).logdata;
        offset = offsets(i);
        x1_offset = x1_offsets(i);
        y1_offset = y1_offsets(i);

        % Extract data
        temp = logdata.tempcont.A;
        dc = 1e3*logdata.voltmeter.v1;  % DC voltage, mV
        [x1, y1, x2, y2, r1, r2] = util.logdata.lockin(logdata.lockin, 'scale1', 1e6, 'scale2', 1e6);

        if options.phase_offset ~= 0
            z1 = x1 + 1i*y1;
            z1 = z1.*exp(1i*options.phase_offset*pi/180);
            x1 = real(z1);
            y1 = imag(z1);
        end

        x1 = x1 - x1_offset;
        y1 = y1 - y1_offset;

        for x = [x1]
            rmcd = x./dc/A; % RMCD in rad
            rmcd = -rmcd*1e6; % RMCD in urad

            % Remove offset
            rmcd_offset = 0;
            if offset_range(1) < offset_range(2)
                idx = temp > offset_range(1) & temp < offset_range(2);
                rmcd_offset = mean(rmcd(idx));
            end
            if offset ~= 0, rmcd_offset = offset; end
            rmcd = rmcd - rmcd_offset;

            % Coarse-grain
            [T, RMCD, RMCD2] = util.coarse.grain(options.dT, temp, rmcd);

            % Plot
            if options.errorbar
                RMCD2 = RMCD2;
                errorbar(ax, T, RMCD, RMCD2, '.-', 'LineWidth', 1, 'DisplayName', name);
            else
                plot(ax, T, RMCD, '.-', 'LineWidth', 1, 'DisplayName', name);
            end
        end
    end
    
    % Format plot
    if ~isnan(options.ylim), ylim(options.ylim); end
    ylabel(ax, '\Delta RMCD \epsilon = \sigma_{\Delta}/\sigma_{\Sigma} (\murad)');
    xlabel(ax, 'Temperature (K)');
    if isempty(options.legends)
        l = legend(ax, 'Location', 'best');
    else
        l = legend(ax, options.legends);
    end
    set(l, 'Interpreter', 'none');
    
    % Save figure
    if options.save
        [~, name, ~] = fileparts(filenames(1));
        save_filename = fullfile('output', strcat(name, '_temp_kerr.png'));
        if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
        saveas(fig, save_filename, 'png');
    end
end
    