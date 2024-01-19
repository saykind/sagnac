function [data, g] = data(filename)
%Load a file and plot the data

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
            %if isfield(data, 'key'), title(g.axes(1), make.title(data.key)); end
            %if isfield(data, 'seed')
            %    [~, info] = make.key(data.seed);
            %    t = title(g.axes(1), info); 
            %    set(t, 'Interpreter', 'none')
            %end
        catch ME
            fprintf("[plot.data] failed to use make.graphics()");
            disp(ME);
        end
    end
end