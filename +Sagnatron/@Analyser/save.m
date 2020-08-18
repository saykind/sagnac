function obj = save(obj, path)
    %Data cropping/saving method
    %   If present, first argument should be either a path to data.mat file
    if isempty(obj.path)
        return
    end
    filepath = obj.path;
    if nargin > 1
        filepath = path;
    end
    
    range = obj.tempRange;
    temp = obj.data.(obj.fieldNames.temperature);
    
    % Check if it makes sence to crop the data.
    if (max(temp) <= range(2) && range(1) <= min(temp))
        if obj.verbose
            disp('Temperature range is to wide, no point to crop.')
        end
        return
    end
    
    % Find new indecies
    idx = find(temp > range(1) & temp < range(2));
    data = load(filepath);
    logData = struct();
    
    % Create new logdata structure
    fn = fieldnames(data.logdata);
    for i = 1:numel(fn)
        if ~isnumeric(data.logdata.(fn{i}))
            continue;
        end
        logData.(fn{i}) = data.logdata.(fn{i})(idx);
    end
    
    data.logdata = logData;
    save(filepath, '-struct', 'data');
    
    if isfile(filepath)
        fprintf("Overwitten: %s\n", filepath);
    else
        fprintf("Saved: %s\n", filepath);
    end
end