function isfolder(folder_name)
%ISFOLDER Check if the folder exists, if it does not, create it.

    if ~isfolder(folder_name)
        mkdir(folder_name);
    end
end