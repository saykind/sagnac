function new_filename = ext(filename, new_ext)
% Adds or changes extension in filename string.
%
% Arguments:
%    filename (1,:) char
%    new_ext (1,:) char
%
% Returns:
%    new_filename (1,:) char
%

    [folder, name, ~] = fileparts(filename);
    new_filename = fullfile(folder, [name, new_ext]);
end
