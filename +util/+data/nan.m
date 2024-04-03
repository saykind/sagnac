function nan(varargin)
    %Replace outliers with NaN in logdata structure
    %   Provide 'range' and 'field' as a arguments
    %   Optional arguments: 'filename', 'saveas'.
    %   Written on 2024/4/2 by saykind@stanford.edu
    %   Example:
    %       util.data.nan('field', 'tempcont.A', 'range', [100, 110])
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'saveas',   '', @ischar);
    addParameter(p, 'field',    '', @ischar);
    addParameter(p, 'range',    [], @isnumeric);
    addParameter(p, 'verbose', true, @islogical);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    saveas = parameters.saveas;
    field = parameters.field;
    range = parameters.range;
    verbose = parameters.verbose;

    if isempty(field) || isempty(range)
        error("Field and range must be provided.");
    end
    
    % If no filename is given, open file browser
    if isempty(filename)
        filenames = util.filename.select();
        filename = filenames{1};
    end
    
    new_filename = util.filename.change(filename, saveas, 'postfix', '-nan');

    data = load(filename);
    logdata = data.logdata;

    if strcmp(field, 'index')
        idx = range(1):range(2);
        num_extra = -1;
    else
        fields = split(field,'.');
        temp = getfield(logdata, fields{:});
        idx = find(temp > range(1) & temp < range(2));
        num_extra = length(temp) - length(idx);
    end
    
    % Remove outliers
    % Loop over structure with two level depth
    fn1 = fieldnames(logdata);
    for i = 1:numel(fn1)
        if strcmp(fn1{i}, 'sweep'), continue; end
        fn2 = fieldnames(logdata.(fn1{i}));
        for j = 1:numel(fn2)
            if ~isnumeric(logdata.(fn1{i}).(fn2{j})), continue; end
            logdata.(fn1{i}).(fn2{j})(idx) = nan;
        end
    end

    if verbose, fprintf("Painted %d outliers.\n", num_extra); end
    
    % Save new logdata structure
    data.logdata = logdata;
    if isfile(new_filename)
        fprintf("Overwitten: %s\n", new_filename);
    else
        fprintf("Saved: %s\n", new_filename);
    end
    save(new_filename, '-struct', 'data');
end