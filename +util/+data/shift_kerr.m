function shift_kerr(varargin)
%Add constant value to kerr signal.
%   Provide 'filename', 'saveas', and 'value' as name-value pairs.
%
%   Assumes that the datafile is a .mat file with a logdata structure
%   which follows convention:
%   logdata.<instrument>.<field> is used to crop the data.
%
%   Written on 2025/7/9 by saykind@stanford.edu
%
%   Example:
%       util.data.crop('value', 1);
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'saveas',   '', @ischar);
    addParameter(p, 'value',    1, @isnumeric);
    addParameter(p, 'verbose', true, @islogical);
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    saveas = parameters.saveas;
    value = parameters.value;
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
    
    filename_new = util.filename.change(filename, saveas, 'postfix', '-shifted');

    data = load(filename);
    logdata = data.logdata;

    % Main function implementation is below
    data.logdata = shifted(logdata, value, verbose);

    if isfile(filename_new)
        fprintf("Overwitten: %s\n", filename_new);
    else
        fprintf("Saved: %s\n", filename_new);
    end
    save(filename_new, '-struct', 'data');
end


function logdata_new = shifted(logdata, value, verbose)
%Helper function

    logdata_new = logdata;

    try 
        sls = .1;
        V1X = logdata.lockin.X;
        V2 = sls*sqrt(logdata.lockin.AUX1.^2+logdata.lockin.AUX2.^2);

        c = besselj(2,1.841)/besselj(1,1.841);
        kerr = .5*atan(c*V1X./V2)*1e6;

        logdata_new.lockin.X = tan(2*1e-6*(kerr + value))/c.*V2;
    catch ME
        if verbose, fprintf("No lockin.X field found.\n"); end
    end
    
end