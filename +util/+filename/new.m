function filename = new(foldername)
%Creates filename string based on current date and time

    if nargin < 1
        foldername = 'data\';
    else
        if ~ischar(foldername), foldername = char(foldername); end
        slash = foldername(end);
        if (slash ~= '\') && (slash ~= '/')
            foldername(end+1) = '\';
        end
    end
    if ~exist(foldername, 'dir'), mkdir(foldername); end
    
    c = clock();
    filename_bare = sprintf('%s%d-%d-%d_%d-%d', ...
        foldername, c(1), c(2), c(3), c(4), c(5));
    
    cnt = 0;
    filename = [filename_bare, '.mat'];
    while exist(filename, 'file')
        filename = [filename_bare, char('a'+cnt), '.mat'];
        cnt = cnt + 1;
    end
end