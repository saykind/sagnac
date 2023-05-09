function rmoutliers(varargin)
    %Remove outliers using built-in rmoutliers function
    %   Provide 'filename', 'saveas' and 'field' as a arguments
    %   Written on 2023/5/7 by saykind@stanford.edu
    %   Example:
    %       util.data.rmoutliers('field', 'lockin.X')
    %       util.data.rmoutliers('filename', 'data/1.mat', 'field', 'diode.voltage')
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'saveas',   '', @ischar);
    addParameter(p, 'field',    '', @ischar);
    addParameter(p, 'verbose', true, @islogical);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    saveas = parameters.saveas;
    field = parameters.field;
    verbose = parameters.verbose;
    
    % If no filename is given, open file browser
    if isempty(filename) 
        [basefilename, folder] = uigetfile('*.mat', 'Select data file');
        filename = fullfile(folder, basefilename);
        if basefilename == 0
            disp('Please supply logdata structure or path to datafile.');
            return;
        end
    end
    
    new_filename = util.new_filename(filename, saveas, 'postfix', '-rmo');

    data = load(filename);
    logdata = data.logdata;
    logData = struct();     % new logdata structure
    
    if ~isempty(field)
        fields = split(field,'.');
        [~, outliers] = rmoutliers(getfield(logdata, fields{:}));
        num_outliers = nnz(outliers);
        % Loop over structure with two level depth
        fn1 = fieldnames(logdata);
        for i = 1:numel(fn1)
            fn2 = fieldnames(logdata.(fn1{i}));
            for j = 1:numel(fn2)
                if ~isnumeric(logdata.(fn1{i}).(fn2{j})), continue; end
                logData.(fn1{i}).(fn2{j}) = ...
                    data.logdata.(fn1{i}).(fn2{j})(~outliers);
            end
        end
        if verbose, fprintf("Removed %d outliers.\n", num_outliers); end
    else
        error("Implmentation without field provided is not finished.");
    end
    
    % Save new logdata structure
    data.logdata = logData;
    if isfile(new_filename)
        fprintf("Overwitten: %s\n", new_filename);
    else
        fprintf("Saved: %s\n", new_filename);
    end
    save(new_filename, '-struct', 'data');
end