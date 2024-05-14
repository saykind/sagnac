function stack = msg(message, varargin)
%MSG  Display a message and stack trace.
%   MSG(MESSAGE) displays the message MSG and the function which called MSG.
%
%   See also ERROR, WARNING, LASTERROR, DBSTACK, MFILENAME.

    % Make formatted message
    if ~isempty(varargin)
        message = sprintf(message, varargin{:});
    end

    % Get the stack
    stack = dbstack('-completenames');

    if length(stack) == 1 %#ok<ISCL>
        source = 'base';
        fprintf('[%s] %s\n', source, message);
        return
    end

    % Get the source file and line number
    filename = stack(2).file;
    line_number = stack(2).line;
    % Remove the home directory from the filename
    homedir = stack(1).file(1:end-11);
    source = strrep(filename, homedir, '');
    % Remove the extension
    source = strrep(source, '.m', '');
    % remove + and @ symbols from the path
    source = strrep(source, '+', '');
    source = strrep(source, '@', '');
    % Determine IDE
    if usejava('desktop')
        % MATLAB: make a link to source file
        link = sprintf('<a href="matlab:opentoline(''%s'',%d)">%s</a>', filename, line_number, source);
    else
        % Other IDEs: use simple text
        link = [source, ':', num2str(line_number)];
    end
    % Display the message
    fprintf('[%s] %s\n', link, message);

end