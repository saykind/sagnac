function plot_data(logdata)
    %Kerr data analysis method
    %   Plots content of the logdata file.
    
    % Check that correct argument is present
    if nargin < 1 
        disp('Please supply logdata structure.');
        return;
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
        'firstHarmonicX', ...
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
        plot(ax, logdata.(xFieldName), logdata.(yFieldName), ...
            '.', 'MarkerSize', 20);
        xlabel(ax, 'Time, sec');
        ylabel(ax, yFieldName);
        grid(ax, 'on');
    end
   
end
