function csv(options)
% open file and save logdata to CSV file.
% file has structure LOGDATA has fields with INSTRUMENT name
% and each field has subfields with DATA name

arguments
    options.filenames (1,:) string = [];
    options.output_folder (1,:) char = 'csv/';
end

    filenames = options.filenames;

    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = convertCharsToStrings(util.filename.select());
        %filenames = flip(filenames);
    end
    if isempty(filenames)
        warning('No file selected.');
        return;
    end
    
    %covert structure to table
    for j = 1:numel(filenames)
        filename = filenames(j);
        logdata = load(filename).logdata;
        fn = fieldnames(logdata);
        for i = 1:numel(fn)
            data = logdata.(fn{i});
            if isstruct(data)
                if fn{i} == "sweep"
                    data = struct('datapoints', data.datapoints'); 
                end
                data = struct2table(data);
                % add common variable (column) index to table before joining
                data.Properties.VariableNames = strcat(fn{i}, {'_'}, data.Properties.VariableNames);
                data = addvars(data, (1:height(data))', 'Before', 1, 'NewVariableNames', 'Index');  

                if i == 1
                    table = data;
                else
                    table = join(table, data, 'LeftKeys', 'Index', 'RightKeys', 'Index');
                end
            end
        end

        %save table to csv file
        [folder, name, ext] = fileparts(filename);
        name = convertStringsToChars(name);
        output = [options.output_folder, name, '.csv'];
        writetable(table, output);
    end

    
end
