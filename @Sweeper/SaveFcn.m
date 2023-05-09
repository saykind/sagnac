function SaveFcn(obj, event)
    %Write data to obj.filename file
    
    if isempty(obj.filename)
        disp("Please provide datafilename.");
        return
    end
    try
        obj.loginfo.timer.TasksExecuted = obj.timer.TasksExecuted;
    catch
        fprintf('[Sweeper] Failed to update loginfo.timer.TasksExecuted.\n');
    end
    
    data = struct('key', obj.key, ...
        'title', obj.title, ...
        'seed', obj.seed, ...
        'range', obj.range, ...
        'schema', obj.schema, ...
        'loginfo', obj.loginfo, ...
        'logdata', obj.logdata);
    save(obj.filename, '-struct', 'data');
    
    fprintf('[%s] saved to %s (%s).\n', obj.title, obj.filename, ...
        datestr(event.Data.time, 'HH:MM:SS'));
end