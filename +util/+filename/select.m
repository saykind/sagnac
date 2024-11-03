function selectedFiles = select(ext)
%SELECT files and return their full paths.
% This function prompts the user to SELECT files using the uigetfile dialog.
%
% Inputs:
%    ext - String representing the file extension to filter the files by.
%
% Outputs:
%    selectedFiles - Cell array of strings representing the full paths of
%                    the selected or specified files.
%
% Example:
%    selectedFiles = select()
%
% See also: UIGETFILE, FULLFILE, EXIST

    arguments
        ext (1,:) char = '*.mat'
    end

    % Prompt the user to select files
    [fileNames, filePaths] = uigetfile(ext, 'Select files', 'MultiSelect', 'on');
    if isequal(fileNames, 0)
        selectedFiles = [];
        return;
    end
    % If only one file is selected, fileNames is a char, not a cell
    if ~iscell(fileNames)
        fileNames = {fileNames};
    end
    % Prepend the path to the file names
    selectedFiles = fullfile(filePaths, fileNames);

end
