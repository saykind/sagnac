function logStart(obj, event)
    %Timer (logger) start function
    
    if isempty(obj.schema)
        fprintf("[Recorder.start] instrument SCHEMA is required.\n");
        obj.logger.stop();
        return
    end

    obj.filename = make.filename(obj.foldername);
    
    if nargin > 1
        startTime = event.Data.time;
        if obj.verbose > 0
            fprintf('[%s] started (%s).\n', obj.title, ...
            datestr(event.Data.time, 'dd-mmm-yyyy HH:MM:SS'));
            if obj.logger.TasksToExecute < inf
                duration = obj.logger.Period*seconds(obj.logger.TasksToExecute);
                stopTime = datetime(startTime) + duration;
                fprintf('[%s] estimated time of completion: %s.\n', obj.title, ...
                    datestr(stopTime, 'dd-mmm-yyyy HH:MM:SS'));
            end
        end
    end

    try
        obj.i();
    catch
        fprintf("[Recorder.start] Failed to initialize instruments.");
        obj.stop();
    end
    if ~isempty(obj.sweep)
        make.sweep(obj.key, obj.instruments, obj.sweep, obj.sweep.rate);
    end
    obj.g();
    obj.logdata = make.logdata(obj.instruments, obj.schema);
    obj.loginfo = make.loginfo(obj.instruments, obj.schema);

    
    % Add timer parametrs to info structure.
    % Do not do this: parameters = fieldnames(obj.logger);
    parameters = {'Name', 'ExecutionMode', ...
        'Period', 'AveragePeriod', 'InstantPeriod', ...
        'TasksToExecute', 'TasksExecuted'};
    for j = 1:numel(parameters)
        parameter = parameters{j};
        obj.loginfo.timer.(parameter) = obj.logger.(parameter);
    end
    
    obj.cnt = 0;
end