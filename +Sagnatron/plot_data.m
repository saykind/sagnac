function plot_data(arg)
    %Kerr data analysis method
    %   Plots content of the logdata file.
    
    % If no argument is given, open file browser
    if nargin < 1 
        [file, folder] = uigetfile('*.mat', 'Select data file');
        if file == 0
            disp('Please supply logdata structure or path to datafile.');
            return;
        end
        filepath = fullfile(folder, file);
        logdata = load(filepath).logdata;
    end
    
    % Check that correct argument is present
    if nargin == 1
        if isstring(arg) || all(ischar(arg))
            logdata = load(arg).logdata;
        else
            logdata = arg;
        end
    end
    
    % Create figure with tabs
    f = figure('Name', 'Transport measurement');
    tg = uitabgroup(f);

    % Finds correct field names in the logdata file
    fieldNames = Sagnatron.determine_field_names(logdata);
    
    % Plot data versus temperature
    xFieldName = fieldNames.temperature;
    yQuantities = {...
        'kerr', ...
        'transportX', ...
        'transportY', ...
        'inductanceX', ...
        'inductanceY', ...
        'firstHarmonicX', ...
        'dc', ...
        'secondHarmonic'};
    num = numel(yQuantities);
    for i=1:num
        yFieldName = fieldNames.(yQuantities{i});
        if isempty(yFieldName)
            continue;
        end
        currentTab = uitab(tg, 'Title', yFieldName);
        ax = axes(currentTab);
        plot(ax, logdata.(xFieldName), logdata.(yFieldName), ...
            '.', 'MarkerSize', 20);
        xlabel(ax, 'Temperature, K');
        ylabel(ax, yFieldName);
        grid(ax, 'on');
    end
    
    % Plot data versus time
    xFieldName = fieldNames.time;
    yQuantities = {...
        'secondHarmonic', ...
        'temperature', ...
        'temperatureMagnet'};
    num = numel(yQuantities);
    for i=1:num
        yFieldName = fieldNames.(yQuantities{i});
        if isempty(yFieldName)
            continue;
        end
        currentTab = uitab(tg, 'Title', yFieldName);
        ax = axes(currentTab);
        plot(ax, logdata.(xFieldName)/60, logdata.(yFieldName), ...
            '.', 'MarkerSize', 20);
        xlabel(ax, 'Time, min');
        ylabel(ax, yFieldName);
        grid(ax, 'on');
    end
   
end
