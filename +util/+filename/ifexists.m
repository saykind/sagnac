function selectedFiles = ifexists(varargin)
%SELECT Checks if files exist and returns their full paths
%
% Syntax: selectedFiles = select(varargin)
%
% Checks if they exist as files and
% returns their full paths. If a file does not exist, a warning is issued.
%
% Inputs:
%    varargin - Strings representing the full paths of the files to check.
%
% Outputs:
%    selectedFiles - Cell array of strings representing the full paths of
%                    the selected or specified files.
%
% Example:
%    selectedFiles = select('data/file1.mat', 'file2.mat')
%
% See also: UIGETFILE, FULLFILE, EXIST

    selectedFiles = {};
    for i = 1:nargin
        if exist(varargin{i}, 'file') == 2
            selectedFiles{end+1} = varargin{i};
        else
            warning(['File does not exist: ' varargin{i}]);
        end
    end
end
