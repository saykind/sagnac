function fig = snapshot(varargin)
    %Kerr data plot method
    %   Plots content of the logdata file.
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'domain', 'temp', @ischar);
    addParameter(p, 'range', [-inf, inf], @isnumeric);
    addParameter(p, 'dT', 1, @isnumeric);
    addParameter(p, 'parametername', 'Parameter', @ischar);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    domain = parameters.domain;
    dT = parameters.dT;
    range = parameters.range;
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
    if isfield(data, 'info')
        if isfield(data.info, 'parametername')
            parametername = data.info.parametername;
        end
    end
    % Configure Figure
    fig = figure('Name', name, ...
        'Units', 'centimeters', ...
        'Position', [0 0 10.5 12.9]);
    set(fig, 'PaperUnits', 'centimeters', 'PaperSize', [11 9]);
    % Choose x-axis data
    switch domain
        case 'time'
            fig = snapshot_time(fig, logdata, range);
            name(end+1) = 'r';
        case 'temp'
            fig = snapshot_temp(fig, logdata, dT, range);
        case 'transport'
            fig = snapshot_transport(fig, logdata, dT, range);
            name(end+1) = 't';
        case 'parameter'
            fig = snapshot_parameter(fig, logdata, dT, range, parametername);
            name(end+1) = 'p';
    end
    saveas(fig, sprintf('output/%s.png', name), 'png');
end

function fig = snapshot_time(fig, logdata, range)
    layout = [2, 1];
    t = tiledlayout(fig, layout(1), layout(2)); 
    ax1 = nexttile(t); ax2 = nexttile(t);
    hold(ax1, 'on'); grid(ax1, 'on'); box(ax1, 'on');
    hold(ax2, 'on'); grid(ax2, 'on'); box(ax2, 'on');
    xlim(ax1, range); xlim(ax2, range);
    
    time = logdata.time;
    sampletemperature = logdata.sampletemperature;
    magnettemperature = logdata.magnettemperature;
    dc = 1e3*logdata.dc;
    second = 1e3*logdata.second;
    
    title(ax1, 'Temperature');
    plot(ax1, time, sampletemperature, '-', 'LineWidth', 1.5, ...
        'Color', [0, 0, 0], 'DisplayName', 'Raw data');
    ylabel(ax1, 'Sample T (K)');
    yyaxis(ax1, 'right');
    ax1.YColor = 'b';
    plot(ax1, time, magnettemperature, '-', 'LineWidth', 1.5, ...
        'Color', [0, 0, 1], 'DisplayName', 'Raw data');
    ylabel(ax1, 'Magnet T (K)');
    yyaxis(ax1, 'left');
    
    % Plot of dc and 2nd harmonic vs temperature
    title(ax2, 'Reflectivity');
    plot(ax2, time, dc, '-', 'LineWidth', 1.5, ...
        'Color', [.75, 0, 0], 'DisplayName', 'Raw data');
    ylabel(ax2, 'V_0 (mV)');
    yyaxis(ax2, 'right');
    ax2.YColor = 'b';
    plot(ax2, time, second, '-', 'LineWidth', 1.5, ...
        'Color', [0, 0, 1], 'DisplayName', 'Raw data');
    ylabel(ax2, '|V_{2\omega}| (mV)');
    yyaxis(ax2, 'left');
    ax2.YColor = 'r';
    xlabel(ax2, 'Time (sec)');
    
end


function fig = snapshot_temp(fig, logdata, dT, range)
    plot_field = 0;
    layout = [3, 1];
    t = tiledlayout(fig, layout(1), layout(2)); 
    ax1 = nexttile(t); ax2 = nexttile(t); ax3 = nexttile(t); 
    hold(ax1, 'on'); grid(ax1, 'on'); box(ax1, 'on');
    hold(ax2, 'on'); grid(ax2, 'on'); box(ax2, 'on');
    hold(ax3, 'on'); grid(ax3, 'on'); box(ax3, 'on');
    xlim(ax1, range); xlim(ax2, range); xlim(ax3, range);
    
    % Data
    fieldNames = determine_field_names(logdata);
    temp = logdata.(fieldNames.temperature);
    firstX = logdata.(fieldNames.firstHarmonicX);
    firstY = logdata.(fieldNames.firstHarmonicY);
    second = 1e3*logdata.(fieldNames.secondHarmonic);
    dc = 1e3*logdata.(fieldNames.dc);
    if isfield(logdata, 'magnet_current')
        curr = 1e3*logdata.magnet_current;
        plot_field = 1;
    else
        plot_field = 0;
        curr = dc;
    end
    if strcmp(fieldNames.kerr, "kerr2")
        kerr = logdata.(fieldNames.kerr)/2;
    else
        kerr = logdata.(fieldNames.kerr);
    end
    
    [T, K, DC, FirstX, FirstY, Second, I] = ...
        Utilities.coarse_grain(dT, temp, kerr, dc, firstX, firstY, second, curr);
    
    % Plot of kerr angle vs temperature
    title(ax1, 'Kerr angle');
    plot(ax1, temp, kerr, '.', 'MarkerSize', .5, ...
        'Color', [.4, 0.4, 0.4], 'DisplayName', 'Raw data');
    plot(ax1, T, K, 'LineWidth', 1.5, 'Color', [0, 0, 0], ...
        'DisplayName', sprintf('dT = %.2f K', dT));
    ylabel(ax1, '\theta_K (\murad)');
    if plot_field
        yyaxis(ax1, 'right');
        ax1.YColor = 'b';
        plot(ax1, temp, curr, '.', 'MarkerSize', .5, ...
            'Color', [.6, .8, 1], 'DisplayName', 'Raw data');
        plot(ax1, T, I, '-', 'LineWidth', 1.5, 'Color', [0, 0, 1], ...
            'DisplayName', sprintf('dT = %.2f K', dT));
        ylabel(ax1, 'Magnet I (mA)');
        yyaxis(ax1, 'left');
    end
    
    
    % Plot of dc and 2nd harmonic vs temperature
    title(ax2, 'Reflectivity');
    plot(ax2, temp, dc, '.', 'MarkerSize', .5, ...
        'Color', [1, .85, .85], 'DisplayName', 'Raw data');
    plot(ax2, T, DC, '-', 'LineWidth', 1.5, 'Color', [.75, 0, 0], ...
        'DisplayName', sprintf('dT = %.2f K', dT));
    ylabel(ax2, 'V_0 (mV)');
    yyaxis(ax2, 'right');
    ax2.YColor = 'b';
    plot(ax2, temp, second, '.', 'MarkerSize', .5, ...
        'Color', [.6, .8, 1], 'DisplayName', 'Raw data');
    plot(ax2, T, Second, '-', 'LineWidth', 1.5, 'Color', [0, 0, 1], ...
        'DisplayName', sprintf('dT = %.2f K', dT));
    ylabel(ax2, '|V_{2\omega}| (mV)');
    yyaxis(ax2, 'left');
    ax2.YColor = 'r';
    
    % Plot of first harmonic vs temperature
    title(ax3, 'First harmonic amplitude');
    plot(ax3, temp, firstX, '.', 'MarkerSize', .5, ...
        'Color', [1, .85, .85], 'DisplayName', 'Raw data');
    plot(ax3, T, FirstX, '-', 'LineWidth', 1.5, 'Color', [.75, 0, 0], ...
        'DisplayName', sprintf('dT = %.2f K', dT));
    ylabel(ax3, 'Re V_{1\omega} (\muV)');
    ax3.YColor = 'r';
    yyaxis(ax3, 'right');
    ax3.YColor = 'b';
    plot(ax3, temp, firstY, '.', 'MarkerSize', .5, ...
        'Color', [.6, .8, 1], 'DisplayName', 'Raw data');
    plot(ax3, T, FirstY, '-', 'LineWidth', 1.5, 'Color', [0, 0, 1], ...
        'DisplayName', sprintf('dT = %.2f K', dT));
    ylabel(ax3, 'Im V_{1\omega} (\muV)');
    yyaxis(ax3, 'left');
    ax3.YColor = 'r';
    xlabel(ax3, 'Temperature (K)');

    %legend(ax1); legend(ax2); legend(ax3);
end

function fig = snapshot_transport(fig, logdata, dT, range)

    % Setting up axis
    ax = axes(fig);
    hold(ax, 'on'); 
    grid(ax, 'on');
    xlim(range);
    plotY = 0;
    
    % Data
    fieldNames = determine_field_names(logdata);
    temp = logdata.(fieldNames.temperatureMagnet);
    transportX = 1e3*logdata.(fieldNames.transportX);
    transportY = 1e3*logdata.(fieldNames.transportY);

    [T, X, Y] = ...
        Utilities.coarse_grain(dT, temp, transportX, transportY);
    
    % Plot
    %plot(ax, temp, transportX, '.', 'MarkerSize', 1, ...
    %    'Color', [.4, 0.4, 0.4], 'DisplayName', 'Raw data');
    plot(ax, T, X, '.', 'LineWidth', 1.5, 'Color', [0, 0, 0], ...
        'DisplayName', sprintf('dT = %.2f K', dT));
    ylabel(ax, 'Transport X (mOhms)');
    if plotY
        yyaxis(ax, 'right');
        ax.YColor = 'b';
        plot(ax, temp, transportY, '.', 'MarkerSize', 1, ...
            'Color', [.6, .8, 1], 'DisplayName', 'Raw data');
        plot(ax, T, Y, '-', 'LineWidth', 1.5, 'Color', [0, 0, 1], ...
            'DisplayName', sprintf('dT = %.2f K', dT));
        ylabel(ax, 'Transport Y (mOhms)');
        yyaxis(ax, 'left');
    end
    xlabel(ax, 'Temperature (K)');
end

function fig = snapshot_parameter(fig, logdata, dT, range, parametername)
    layout = [3, 1];
    t = tiledlayout(fig, layout(1), layout(2)); 
    ax1 = nexttile(t); ax2 = nexttile(t); ax3 = nexttile(t); 
    hold(ax1, 'on'); grid(ax1, 'on'); box(ax1, 'on');
    hold(ax2, 'on'); grid(ax2, 'on'); box(ax2, 'on');
    hold(ax3, 'on'); grid(ax3, 'on'); box(ax3, 'on');
    xlim(ax1, range); xlim(ax2, range); xlim(ax3, range);
    
    % Data
    fieldNames = determine_field_names(logdata);
    T = logdata.parameter;
    FirstX = logdata.(fieldNames.firstHarmonicX);
    FirstX = FirstX - mean(FirstX);
    FirstY = logdata.(fieldNames.firstHarmonicY);
    Second = logdata.(fieldNames.secondHarmonic);
    DC = 1e3*logdata.(fieldNames.dc);
    K = Sagnatron.calculate_kerr(FirstX, Second);
    
    
    % Plot of kerr angle vs temperature
    title(ax1, 'Kerr angle');
    plot(ax1, T, K, 'LineWidth', 1.5, 'Color', [0, 0, 0], ...
        'DisplayName', sprintf('dT = %.2f K', dT));
    ylabel(ax1, '\theta_K (\murad)');
    
    % Plot of dc and 2nd harmonic vs temperature
    title(ax2, 'Reflectivity');
    plot(ax2, T, DC, '-', 'LineWidth', 1.5, 'Color', [.75, 0, 0], ...
        'DisplayName', sprintf('dT = %.2f K', dT));
    ylabel(ax2, 'V_0 (mV)');
    yyaxis(ax2, 'right');
    ax2.YColor = 'b';
    plot(ax2, T, Second, '-', 'LineWidth', 1.5, 'Color', [0, 0, 1], ...
        'DisplayName', sprintf('dT = %.2f K', dT));
    ylabel(ax2, '|V_{2\omega}| (mV)');
    yyaxis(ax2, 'left');
    ax2.YColor = 'r';
    
    % Plot of first harmonic vs temperature
    title(ax3, 'First harmonic amplitude');
    plot(ax3, T, FirstX, '-', 'LineWidth', 1.5, 'Color', [.75, 0, 0], ...
        'DisplayName', sprintf('dT = %.2f K', dT));
    ylabel(ax3, 'Re V_{1\omega} (\muV)');
    ax3.YColor = 'r';
    yyaxis(ax3, 'right');
    ax3.YColor = 'b';
    plot(ax3, T, FirstY, '-', 'LineWidth', 1.5, 'Color', [0, 0, 1], ...
        'DisplayName', sprintf('dT = %.2f K', dT));
    ylabel(ax3, 'Im V_{1\omega} (\muV)');
    yyaxis(ax3, 'left');
    ax3.YColor = 'r';
    xlabel(ax3, parametername);

    %legend(ax1); legend(ax2); legend(ax3);
end




function fieldNames = determine_field_names(logdata)
    %Kerr data analysis method
    %   Returns correct logdata structure field names.
    
    possibleFieldNames = struct(...
        'kerr', ["kerr", "kerr2"], ...
        'transportX', ["transport", "transportX"], ...
        'transportY', ["transporty", "transportY"], ...
        'transportR', ["transportr", "transportR"], ...
        'resistanceX', ["resistancex", "resistanceX", "transportx", "transportX"], ...
        'resistanceY', ["resistancey", "resistanceY", "transporty", "transportY"], ...
        'inductanceX', ["incductancex", "inductanceX", "transportx", "transportX"], ...
        'inductanceY', ["inductancey", "inductanceY", "transporty", "transportY"], ...
        'firstHarmonicX', ["firstX", "firstx", "first", "X"], ...
        'firstHarmonicY', ["firstY", "firsty", "Y"], ...
        'secondHarmonic',  ["second", "AUX1"], ...
        'dc',  ["dc", "DC"], ...
        'temperature', ["temp", "temperature", "sampletemperature"], ...
        'temperatureMagnet', ["magnettemperature", "temperatureMagnet"], ...
        'time', ["time", "Time"]);
    
    fields = fieldnames(possibleFieldNames);
    numFields = numel(fields);
    fieldNames = cell2struct(cell(numFields, 1), fields);

    for i = 1:numFields
        field = fields{i};
        for fieldName = possibleFieldNames.(field)
            if isfield(logdata, fieldName)
                fieldNames.(field) = fieldName;
                break;
            end
        end
        if isempty(fieldNames.(field))
            %fprintf("Field <<%s>> is not present.\n", field);
        end
    end
end 