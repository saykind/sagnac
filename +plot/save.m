function save(fig, options)
% SAVE Save the figure to a file.
% Options is a structure, not Name-Value pairs.

    try
        filenames = options.filenames;
        save = options.save;
        folder_name = options.save_folder;
        verbose = options.verbose;
    catch
        util.msg('Required OPTIONS structure is missing.');
        return
    end

    if save
        [~, name, ~] = fileparts(filenames(1));
        if ~isfolder(folder_name)
            mkdir(folder_name);
        end
        save_filename = fullfile('output', strcat(name, '_temp_kerr.png'));
        if verbose
            util.msg('Saving figure to %s\n', save_filename);
        end
        exportgraphics(fig, save_filename, 'Resolution', 300);
    end