function filename = new(options)
%Creates filename string based on current date and time

    arguments
        options.foldername char = 'data\';
        options.datetime datetime = datetime('now');
        options.appendix char = '';
    end

    foldername = options.foldername;
    if ~ischar(foldername), foldername = char(foldername); end
    slash = foldername(end);
    if (slash ~= '\') && (slash ~= '/')
        foldername(end+1) = '\';
    end
    if ~exist(foldername, 'dir'), mkdir(foldername); end
    
    filename_bare = sprintf('%s%s%s', ...
        foldername, ...
        datetime(options.datetime, "Format", "yyyy-MM-dd_HH-mm-ss"), ...
        options.appendix);
    
    cnt = 0;
    filename = [filename_bare, '.mat'];
    while exist(filename, 'file')
        filename = [filename_bare, '-', char('a'+cnt), '.mat'];
        cnt = cnt + 1;
    end
end