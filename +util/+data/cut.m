function cut(varargin)
    %Data cropping/saving method
    %   Provide new range as an argument
    %   Written on 2022/11/02 by saykind@stanford.edu
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'new_name', '', @ischar);
    addParameter(p, 'field', 'sampletemperature', @ischar);
    addParameter(p, 'range', [-inf, inf], @isnumeric);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    new_name = parameters.new_name;
    field = parameters.field;
    range = parameters.range;
    
    % If no filename is given, open file browser
    if isempty(filename) 
        [basefilename, folder] = uigetfile('*.mat', 'Select data file');
        filename = fullfile(folder, basefilename);
        if basefilename == 0
            disp('Please supply logdata structure or path to datafile.');
            return;
        end
    end
    [foldername, name, ~] = fileparts(filename);
    if isempty(new_name)
        new_name = name;
    end
    data = load(filename);
    logdata = data.logdata;
    temp = logdata.(field);
    
    % Check if it makes sence to crop the data.
    if (max(temp) <= range(2) && range(1) <= min(temp))
        disp('Temperature range is too wide, no point to crop.')
        return
    end
    
    % Find new indecies
    idx = find(temp > range(1) & temp < range(2));
    % Create new logdata structure
    logData = struct();
    fn = fieldnames(data.logdata);
    for i = 1:numel(fn)
        if ~isnumeric(data.logdata.(fn{i}))
            continue;
        end
        logData.(fn{i}) = data.logdata.(fn{i})(idx);
    end
    
    data.logdata = logData;
    new_filename = [foldername, '\', new_name, '.mat'];
    
    if isfile(new_filename)
        fprintf("Overwitten: %s\n", new_filename);
    else
        fprintf("Saved: %s\n", new_filename);
    end
    save(new_filename, '-struct', 'data');
end