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
    addParameter(p, 'verbose', true, @islogical);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filenames = parameters.filenames;
    saveas = parameters.saveas;
    dim = parameters.dim;
    verbose = parameters.verbose;
    
    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = [];
        folder = 1;
        while folder ~= 0 
            [basefilename, folder] = uigetfile('*.mat', 'Select data file');
            filename = fullfile(folder, basefilename);
            filenames = [filenames, string(filename)];
        end
    end
    filenames(end) = [];
    
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
            if strcmp(fn1{i}, 'sweep')
                new_logdata.sweep = logdata.sweep;
                continue
            end
            fn2 = fieldnames(logdata.(fn1{i}));
            for j = 1:numel(fn2)
                if ~isnumeric(logdata.(fn1{i}).(fn2{j})), continue; end
                new_logdata.(fn1{i}).(fn2{j}) = cat(dim, ...
                    new_logdata.(fn1{i}).(fn2{j}), logdata.(fn1{i}).(fn2{j}));
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