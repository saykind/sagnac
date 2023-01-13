function cut_data_file(filename, range)
% Rewrites data file with data only in the given range

if exist(filename, 'file')
    data = load(filename);
    logdata = data.logdata;
    readme = data.readme;
    info = data.info;
else
    disp('No such file');
    return
end


fn = fieldnames(logdata);
for k=1:numel(fn)
    logdata.(fn{k}) = logdata.(fn{k})(range);
end


save(filename, 'readme','info','logdata');