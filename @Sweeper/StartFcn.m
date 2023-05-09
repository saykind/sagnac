function StartFcn(obj, event)
    %Timer start function
    
    if isempty(obj.schema)
        fprintf("[Sweeper.start] instrument SCHEMA is required.\n");
        obj.timer.stop();
        return
    end
    
    obj.filename = obj.make_filename(obj.foldername);
    
    if nargin > 1
        startTime = event.Data.time;
        fprintf('[%s] started (%s).\n', obj.title, ...
        datestr(event.Data.time, 'dd-mmm-yyyy HH:MM:SS'));
        if obj.timer.TasksToExecute < inf
            stopTime = datetime(startTime) + seconds(obj.timer.TasksToExecute);
            fprintf('[%s] estimated time of complition: %s.\n', obj.title, ...
                datestr(stopTime, 'dd-mmm-yyyy HH:MM:SS'));
        end
    end
    
    try
        obj.instruments_init();
    catch
        fprintf("[Sweeper.start] Failed to initialize instruments.");
        obj.stop();
    end
    obj.graphics_init();
    obj.logdata = Sweeper.make_logdata(obj.instruments, obj.schema);
    obj.loginfo = Sweeper.make_loginfo(obj.instruments, obj.schema);
    
    
    % Add timer parametrs to info structure.
    % Do not do this: parameters = fieldnames(obj.timer);
    parameters = {'Name', 'ExecutionMode', ...
        'Period', 'AveragePeriod', 'InstantPeriod', ...
        'TasksToExecute', 'TasksExecuted'};
    for j = 1:numel(parameters)
        parameter = parameters{j};
        obj.loginfo.timer.(parameter) = obj.timer.(parameter);
    end
    
    obj.cnt = 0;
end