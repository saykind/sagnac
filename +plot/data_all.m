function g = data_all(filename, options)
%Load a files and plot the data from all files on the same figure.
% 
%  Input Arguments:
%  - <empty> :  When no arguments given, file browser opens.
%  - filename : filename to load.
%  - options :  Options for the plot.
%
%  Output Arguments:
%  - g :        Graphics handle.
%
%  Example:
%  plot.data_all();
%
%  See also plot.data();

    % If no argument is given, open file browser
    if nargin < 1 
        filenames = convertCharsToStrings(util.filename.select());
    end

    data = load(filenames(1));
    seed = data.schema.Properties.CustomProperties.Seed;
    try
        g = pull.(seed).canvas();
    catch ME
        util.msg("Failed to use pull.canvas()");
        util.msg(ME);
    end

    for filename = filenames
        data = load(filename);
        if seed ~= data.schema.Properties.CustomProperties.Seed
            util.msg("Seed mismatch in %s", filename);
            return
        end
        pull.(seed).plot(g, data.logdata);
    end
end