function obj = load(obj, arg)
    %Data acquisition method 
    %   First argument should be either a path to data.mat file or a logdata
    %   structure. Call without an argument is equivalent to obj.load(obj.path)
    if nargin < 2
        filepath = obj.path;
        if isempty(obj.path)
            [file, folder] = uigetfile('*.mat', 'Select data file');
            if file == 0
                return;
            end
            filepath = fullfile(folder, file);
        end
        obj = obj.load(filepath);
        return;
    end
    
    if isstruct(arg)
        obj.data = arg;
    elseif ischar(arg) || isstring(arg)
        obj.path = arg;
        data = load(arg);
        obj.data = data.logdata;
        
        commentsFields = ["comments", "info"];
        commentsField = commentsFields(1);
        for field = commentsFields
            if isfield(data, field)
                commentsField = field;
            end
        end
        obj.comments = data.(commentsField);
    else
        error('Wrong path/logdata structure');
    end
    
    % Change parameter default values
    temperatureFields = ["temp", "temperature", "sampletemperature"];
    temperatureField = temperatureFields(1);
    for field = temperatureFields
        if isfield(obj.data, field)
            temperatureField = field;
        end
    end
    
    obj.offsetRange = [.5, 1]*max(obj.data.(temperatureField));
end