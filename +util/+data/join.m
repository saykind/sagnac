function join(varargin)
    %Joins (concatinates) two datafiles
    %   Provide new name as an argument
    %   Written on 2022/11/02 by saykind@stanford.edu
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filenames', [], @isstring);
    addParameter(p, 'new_name', '', @ischar);
    parse(p, varargin{:});
    parameters = p.Results;
    filenames = parameters.filenames;
    new_name = parameters.new_name;
    
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
    [foldername, name, ~] = fileparts(filenames(1));
    if isempty(new_name)
        new_name = sprintf('%s_new', name);
    end
    
    % Check if more then one filename provided
    if numel(filenames) < 2
        disp("More then one file is required.")
        return
    end
    
    new_data = load(filenames(1));
    new_logdata = new_data.logdata;
    fn = fieldnames(new_logdata);
    
    % Concatinate data
    for i = 2:numel(filenames) 
        data = load(filenames(i));
        logdata = data.logdata;
        for j = 1:numel(fn)
            new_logdata.(fn{j}) = cat(2, new_logdata.(fn{j}), logdata.(fn{j}));
        end
    end
    
    new_data.logdata = new_logdata;
    new_filename = sprintf('%s\\%s.mat', foldername, new_name);
    
    if isfile(new_filename)
        fprintf("Overwitten: %s\n", new_filename);
    else
        fprintf("Saved: %s\n", new_filename);
    end
    save(new_filename, '-struct', 'new_data');
end