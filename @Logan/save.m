function save(obj, filename)
% Write data to file
    
    arguments
        obj;
        filename string = util.filename.new();
    end
    
    data = struct(...
        'schema', obj.schema, ...
        'loginfo', obj.loginfo, ...
        'logdata', obj.logdata);
    save(filename, '-struct', 'data');
    
    if obj.verbose > 1
        now = datetime('now', 'Format', 'HH:mm:ss');
        fprintf('[%s] (%s) saved to %s.\n', obj.seed, now, filename);
    end
end