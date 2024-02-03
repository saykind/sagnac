function selectedFiles = select(varargin)
%SELECT Selects files and returns their full paths
%
% Syntax: selectedFiles = select(varargin)
%
% This function prompts the user to select .mat files if no arguments are
% provided. If arguments are provided, it checks if they exist as files and
% returns their full paths. If a file does not exist, a warning is issued.
%
% Inputs:
%    varargin - Optional. One or more strings representing file paths.
%
% Outputs:
%    selectedFiles - Cell array of strings representing the full paths of
%                    the selected or specified files.
%
% Example:
%    selectedFiles = select()
%    selectedFiles = select('file1.mat', 'file2.mat')
%
% See also: UIGETFILE, FULLFILE, EXIST
    if nargin == 0
        % Prompt the user to select files
        [fileNames, filePaths] = uigetfile('*.mat', 'Select files', 'MultiSelect', 'on');
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
    else
        selectedFiles = {};
        for i = 1:nargin
            if exist(varargin{i}, 'file') == 2
                selectedFiles{end+1} = varargin{i};
            else
                warning(['File does not exist: ' varargin{i}]);
            end
        end
    end
end
