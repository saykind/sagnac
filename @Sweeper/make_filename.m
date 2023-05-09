function filename = make_filename(foldername)
%Creates filename string based on current datae and time

    if nargin < 1
        foldername = 'data\';
    else
        if ~ischar(foldername)
            foldername = char(foldername);
        end
        if foldername(end) ~= '\'
            foldername(end+1) = '\';
        end
    end
    if ~exist(foldername, 'dir')
       mkdir(foldername);
    end
    
    c = clock();
    filename = sprintf('%s%d-%d-%d_%d-%d.mat', ...
        foldername, c(1), c(2), c(3), c(4), c(5));
    
    filename_bare = filename(1:end-4);
    cnt = 0;
    while exist(filename, 'file')
        filename = [filename_bare, char('a'+cnt), '.mat'];
        cnt = cnt + 1;
    end
end