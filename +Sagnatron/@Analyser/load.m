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
        obj.fieldNames = Sagnatron.determine_field_names(obj.data);
    elseif ischar(arg) || isstring(arg)
        obj.path = arg;
        temp = split(obj.path, '/');
        obj.filename = temp{end};
        
        fileData = load(arg);
        obj.data = fileData.logdata;
        obj.fieldNames = Sagnatron.determine_field_names(obj.data);
        
        commentsFields = ["comments", "info"];
        commentsField = commentsFields(1);
        for field = commentsFields
            if isfield(fileData, field)
                commentsField = field;
            end
        end
        obj.comments = fileData.(commentsField);
    else
        error('Wrong path/logdata structure');
    end
    
    % Flush datafile comments
    fprintf(repmat('~',1,100)+"\n");
    fprintf("Loaded %s\n\n", obj.filename);
    disp(obj.comments);
    fprintf("\n");
    
    % Change parameter default values
    obj.offsetRange = [.5, 1]*max(obj.data.(obj.fieldNames.temperature));
end