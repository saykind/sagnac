function extract_temperature()

    % Select folder
    folder = uigetdir();

    % Get all files in folder
    files = dir(fullfile(folder, '*.mat'));

    % Make an empty table with two columns "filename" and "temperature"
    tab = table('Size', [0, 8], ...
        'VariableNames', {'filename', 'datetime', 'temp1', 'temp2', 'temp', 'kerr1', 'kerr2', 'kerr'}, ...
        'VariableTypes', {'string', 'datetime', 'double', 'double', 'double', 'double', 'double', 'double'});


    % Loop through all files
    for i = 1:length(files)
        filename = files(i).name;
        datetimestamp = filename(1:end-4);

        % Load data
        data = load(fullfile(files(i).folder, filename));
        logdata = data.logdata;

        % Check if the data is a temprature measurement
        if ~isfield(logdata, 'tempcont')
            continue;
        end

        % Covert filename to datetime
        dt = datetime(datetimestamp, 'InputFormat', 'yyyy-M-d_H-m');
        % Add 1 minute
        dt = dt + minutes(1);
        % Convert to string
        datetime_str = string(dt, 'yyyy-M-d_H-m');

        % Extract temperature
        temp1 = min(logdata.tempcont.A);
        temp2 = max(logdata.tempcont.A);
        temp = mean(logdata.tempcont.A);

        % Extract kerr data
        data = load(fullfile(files(i).folder, strcat(datetime_str, '.mat')));
        logdata = data.logdata;

        kerr = util.logdata.kerr(logdata.lockin);
        dc = logdata.voltmeter.v1;
        kerr = kerr + 0.217./dc;
        k1 = min(kerr);
        k2 = max(kerr);
        k = mean(kerr);

        % Add to table
        tab = [tab; {datetime_str, dt, temp1, temp2, temp, k1, k2, k}];
    end

    % Sort table by datetime
    tab = sortrows(tab, 'datetime');

    %figure;
    %plot(tab.temp, tab.kerr, 'o');

    % Save table
    writetable(tab, fullfile(folder, 'tab.csv'));

end
