function new_filename = change(filename, new_name, varargin)
%Creates filename using folder and extension from another filename.
%
%   Examples:
%       'data\2.mat' = change('data\1.mat', '2')
%       'data\1a.mat' = change('data\1.mat', '')
%       '.\2.mat' = change('data\1.mat', './2')
%       'data\1.csv' = change('data\1.mat', '1.csv')
%       'data\1a.mat' = change('data\1.mat', '1')
%       'data\1.mat' = change('data\1.mat', '1', 'overwrite', true)
    
    % Default parameters
    if ispc
        defaultSlash = '\'; % Windows (\)
    else
        defaultSlash = '/'; % UNIX (/)
    end
    
    % Acquire parameters
    p = inputParser;
    addParameter(p, 'slash', defaultSlash, @ischar);     % Windows (\) or UNIX (/)
    addParameter(p, 'postfix', '', @ischar);
    addParameter(p, 'overwrite', false, @islogical);
    parse(p, varargin{:});
    parameters = p.Results;
    slash = parameters.slash;
    postfix = parameters.postfix;
    overwrite = parameters.overwrite;

    if isstring(filename), filename = char(filename); end
    if isstring(new_name), new_name = char(new_name); end

    [folder, name, ext] = fileparts(filename);
    [new_folder, new_name, new_ext] = fileparts(new_name);
    
    if isempty(new_folder), new_folder = folder; end
    if isempty(new_ext), new_ext = ext; end
    if isempty(new_name), new_name = name; end
       
    new_filename = [new_folder, slash, new_name, postfix, new_ext];
    %disp(new_filename)
    
    if ~overwrite
        new_filename_bare = [new_folder, slash, new_name];
        cnt = 0;
        while exist(new_filename, 'file')
            new_filename = [new_filename_bare, char('a'+cnt), new_ext];
            cnt = cnt + 1;
        end
    end
end