function [data, g] = data(filename)
%Load a file and plot the data.
% 
%  Input Arguments:
%  - <empty> :  When no arguments given, file browser opens.
%  - filename : filename to load.
%
%  Output Arguments:
%  - data :     Output of load(filename).
%  - g :        Graphics handle.
%
%  Example:
%  plot.data();
%
%  See also plot.kerr();

    % If no argument is given, open file browser
    if nargin < 1 
        [file, folder] = uigetfile('*.mat', 'Select data file');
        if file == 0
            disp('Please supply a filename or select a file.');
            return;
        end
        filename = fullfile(folder, file);
    end
    data = load(filename);

    if isfield(data, 'key') && isfield(data, 'logdata')
        try
            g = make.graphics(data.key, make.graphics(data.key), data.logdata);
        catch ME
            fprintf("[plot.data] failed to use make.graphics()");
            disp(ME);
        end
    end
end