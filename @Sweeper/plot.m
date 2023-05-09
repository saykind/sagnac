function data = plot(filename)
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
        g = Sweeper.make_plot(data.key, ...
            Sweeper.make_graphics(data.key), data.logdata);
    end
    
    [~, name, ~] = fileparts(filename);
    foldername = "output\";
    if ~exist(foldername, 'dir'), mkdir(foldername); end
    figfilename = fullfile(foldername, strcat(name, ".png"));
    saveas(g.figure, figfilename);
end