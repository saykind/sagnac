function new_filename = change(filename, new_name, varargin)
%Creates filename using folder and extension from another filename.
%
%   Examples:
%       'data\2.mat' = new_filename('data\1.mat', '2')
%       'data\1a.mat' = new_filename('data\1.mat', '')
%       '.\2.mat' = new_filename('data\1.mat', './2')
%       'data\1.csv' = new_filename('data\1.mat', '1.csv')
%       'data\1a.mat' = new_filename('data\1.mat', '1')
%       'data\1.mat' = new_filename('data\1.mat', '1', 'overwrite', true)


    % Acquire parameters
    p = inputParser;
    addParameter(p, 'slash', '\', @ischar);     % Windows (\) or UNIX (/)
    addParameter(p, 'postfix', '', @ischar);
    addParameter(p, 'overwrite',  false, @islogical);
    parse(p, varargin{:});
    parameters = p.Results;
    slash = parameters.slash;
    postfix = parameters.postfix;
    overwrite = parameters.overwrite;

    [folder, name, ext] = fileparts(filename);
    [new_folder, new_name, new_ext] = fileparts(new_name);
    
    if isempty(new_folder), new_folder = folder; end
    if isempty(new_ext), new_ext = ext; end
    if isempty(new_name), new_name = name; end
       
    new_filename = [new_folder, slash, new_name, postfix, new_ext];
    
    if ~overwrite
        new_filename_bare = [new_folder, slash, new_name];
        cnt = 0;
        while exist(new_filename, 'file')
            new_filename = [new_filename_bare, char('a'+cnt), new_ext];
            cnt = cnt + 1;
        end
    end
end