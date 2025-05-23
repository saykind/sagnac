function cat(varargin)
    %Joins (concatinates) two or more datafiles
    %   Provide 'filenames' and 'saveas' as a arguments.
    %   Written on 2023/6/12 by saykind@stanford.edu
    %
    %   TODO:
    %       Check that fieldnames exist in all files.
    %
    %   Parameters:
    %       filenames   - files to concatenate
    %       saveas      - new filename
    %       dim         - along which dim to cat (default: 1)
    %       verbose     - print info (default: true)
    %
    %   Example:
    %       util.data.cat('saveas', 'data/new.mat');
    %       util.data.cat('filenames', ["data/1.mat", "data/2.mat"])
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filenames', [], @isstring);
    addParameter(p, 'saveas',   '', @ischar);
    addParameter(p, 'dim',   1, @isnumeric);
    addParameter(p, 'verbose', false, @islogical);
    addParameter(p, 'reverse', false, @islogical);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filenames = parameters.filenames;
    saveas = parameters.saveas;
    dim = parameters.dim;
    verbose = parameters.verbose;
    
    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = convertCharsToStrings(util.filename.select());
    end

    if parameters.reverse
        filenames = fliplr(filenames);
    end
    
    filename = filenames(1);
    new_filename = util.filename.change(filename, saveas, 'postfix', '-cat');
    
    % Concatinate data
    new_data = load(filenames(1));
    if verbose, fprintf("Opened %s.\n", filenames(1)); end
    new_logdata = new_data.logdata;
    
    for k = 2:numel(filenames) 
        data = load(filenames(k));
        if verbose, fprintf("Opened %s.\n", filenames(k)); end
        logdata = data.logdata;
        % Loop over structure with two level depth
        fn1 = fieldnames(logdata);
        for i = 1:numel(fn1)
            if verbose, fprintf("\t field = %s\n", fn1{i}); end
            if strcmp(fn1{i}, 'sweep')
                new_logdata.sweep = logdata.sweep;
                continue
            end
            fn2 = fieldnames(logdata.(fn1{i}));
            for j = 1:numel(fn2)
                if verbose, fprintf("\t\t subfield = %s\n", fn2{j}); end
                if ~isnumeric(logdata.(fn1{i}).(fn2{j})) && ~isdatetime(logdata.(fn1{i}).(fn2{j}))
                    if verbose, fprintf("\t\t\t Not numeric or datetime. Skipping.\n"); end
                    continue
                end
                size1 = size(new_logdata.(fn1{i}).(fn2{j}));
                new_logdata.(fn1{i}).(fn2{j}) = cat(dim, ...
                    new_logdata.(fn1{i}).(fn2{j}), logdata.(fn1{i}).(fn2{j}));
                if verbose
                    size2 = size(logdata.(fn1{i}).(fn2{j}));
                    size_new = size(new_logdata.(fn1{i}).(fn2{j}));
                    fprintf("\t\t\t size1 = %s\n", mat2str(size1));
                    fprintf("\t\t\t size2 = %s\n", mat2str(size2));
                    fprintf("\t\t\t new size = %s\n", mat2str(size_new));
                end
            end
        end
    end

    
    % Save new logdata structure
    data.logdata = new_logdata;
    if isfile(new_filename)
        fprintf("Overwitten: %s\n", new_filename);
    else
        fprintf("Saved: %s\n", new_filename);
    end
    save(new_filename, '-struct', 'data');
end