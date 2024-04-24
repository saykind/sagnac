function save(obj, event)
    %Write data to obj.filename file
    
    if isempty(obj.filename)
        disp("Please provide datafilename.");
        return
    end
    try
        if ~isempty(obj.logger)
            obj.loginfo.logger.TasksExecuted = obj.logger.TasksExecuted;
        end
    catch
        fprintf('[%s] Failed to update loginfo.timer.TasksExecuted.\n', obj.title);
    end
    
    data = struct('key', obj.key, ...
        'seed', obj.seed, ...
        'title', obj.title, ...
        'schema', obj.schema, ...
        'loginfo', obj.loginfo, ...
        'logdata', obj.logdata);
    save(obj.filename, '-struct', 'data');
    
    if obj.verbose > 1
        if nargin > 1
            fprintf('[%s] saved to %s (%s).\n', obj.title, obj.filename, ...
                datestr(event.Data.time, 'HH:MM:SS'));
        else
            fprintf('[%s] saved to %s.\n', obj.title, obj.filename);
        end
    end
end