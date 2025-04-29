function crop(varargin)
%Crop data given field name and range.
%   Provide 'filename', 'saveas', 'field' and 'range' as name-value pairs.
%
%   Assumes that the datafile is a .mat file with a logdata structure
%   which follows convention:
%   logdata.<instrument>.<field> is used to crop the data.
%
%   Written on 2023/5/7 by saykind@stanford.edu
%
%   Example:
%       util.data.crop('field', 'tempcont.A', 'range', [5, 100]);
%       util.data.crop('filename', 'data/1.mat', 'field', 'tempcont.A', 'range', [5, 10]);
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'saveas',   '', @ischar);
    addParameter(p, 'field',    '', @ischar);
    addParameter(p, 'sweep',    struct(), @isstruct);
    addParameter(p, 'range',    [], @isnumeric);
    addParameter(p, 'verbose', true, @islogical);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    saveas = parameters.saveas;
    field = parameters.field;
    sweep_new = parameters.sweep;
    range = parameters.range;
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
    
    filename_new = util.filename.change(filename, saveas, 'postfix', '-cropped');

    data = load(filename);
    logdata = data.logdata;

    % Main function implementation is below
    data.logdata = cropfield(logdata, field, range, verbose);

    if ~isempty(sweep_new)
        data.logdata.sweep = sweep_new;
    end

    if isfile(filename_new)
        fprintf("Overwitten: %s\n", filename_new);
    else
        fprintf("Saved: %s\n", filename_new);
    end
    save(filename_new, '-struct', 'data');
end


function logdata_new = cropfield(logdata, field, range, verbose)
%Helper function to crop a field in logdata structure when
%   field and range are provided.

    logdata_new = struct();
    
    if ~isempty(field) && ~isempty(range)
        if strcmp(field, 'index')
            idx = range(1):range(2);
            num_extra = length(logdata) - length(idx);
        else
            fields = split(field,'.');
            temp = getfield(logdata, fields{:});
            idx = find(temp > range(1) & temp < range(2));
            num_extra = length(temp) - length(idx);
        end
        
        % Loop over structure with two level depth
        fn1 = fieldnames(logdata);
        for i = 1:numel(fn1)
            if strcmp(fn1{i}, 'sweep')
                logdata_new.sweep = logdata.sweep;
                continue
            end
            fn2 = fieldnames(logdata.(fn1{i}));
            for j = 1:numel(fn2)
                if ~isnumeric(logdata.(fn1{i}).(fn2{j})) && ~isdatetime(logdata.(fn1{i}).(fn2{j}))
                    continue; 
                end
                logdata_new.(fn1{i}).(fn2{j}) = ...
                logdata.(fn1{i}).(fn2{j})(idx,:); 
            end
        end
        if verbose, fprintf("Removed %d points.\n", num_extra); end
    else
        error("Implmentation without field and range provided isn't ready."); %FIXME
    end
end