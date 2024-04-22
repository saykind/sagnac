function seed(new_seed, varargin)
    %Change 'seed' string in the datafile.
    %Check that key is the same.
    %
    %   Written on 2023/07/03 by saykind@stanford.edu
    
    if nargin < 1, error("[util.data.seed] Provide new seed."); end
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'new_name', '', @ischar);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    new_name = parameters.new_name;
    
    % If no filename is given, open file browser
    if isempty(filename) 
        [basefilename, folder] = uigetfile('*.mat', 'Select data file');
        filename = fullfile(folder, basefilename);
        if basefilename == 0
            disp('Please supply path to datafile.');
            return;
        end
    end
    [foldername, name, ~] = fileparts(filename);
    if isempty(new_name)
        new_name = name;
    end
    
    % Change seed.
    data = load(filename);
    
    if ~isfield(data, 'seed'), error("[util.data.seed] Seed not found."); end
    
    key_old = make.key(data.seed);
    key_new = make.key(new_seed);
    
    if key_new ~= key_old, error("[util.data.seed] Key mismatch."); end
    
    data.seed = new_seed;
    
    % Save new datafile
    new_filename = [foldername, '\', new_name, '.mat'];
    if isfile(new_filename)
        fprintf("Overwitten: %s\n", new_filename);
    else
        fprintf("Saved: %s\n", new_filename);
    end
    save(new_filename, '-struct', 'data');
end