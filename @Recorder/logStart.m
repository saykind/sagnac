function logStart(obj, event)
    %Timer (logger) start function
    %   Initializes instruments, graphics, logdata, and loginfo. 
    
    % Check that schema exists.
    if isempty(obj.schema)
        fprintf("[Recorder.start] instrument SCHEMA is required.\n");
        obj.logger.stop();
        return
    end

    % Make data filename
    obj.filename = make.filename(obj.foldername);
    
    % Print start message
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

    % Initialize intruments
    try
        if isempty(obj.instruments), obj.i(); end
    catch
        fprintf("[Recorder.start] Failed to initialize instruments.\n");
        obj.stop();
    end
    
    % Pre-set instrument parameters.
    try
        if ~isempty(obj.sweep)
            make.sweep(obj.key, obj.instruments, obj.sweep);
            obj.rec = 0;
            if obj.verbose > 99, fprintf("[%s] rec=%d\n", obj.title, obj.rec); end
        end
    catch
        fprintf("[Recorder.start] Failed to preset instruments.\n");
        obj.stop();
    end
    
    % Initialize graphics
    try
        obj.g();
    catch
        fprintf("[Recorder.start] Failed to initialize graphics.\n");
        obj.graphics = [];
    end

    % Initialize logdata structure
    try
        obj.logdata = make.logdata(obj.instruments, obj.schema);
        if ~isempty(obj.sweep), obj.logdata.sweep = obj.sweep; end
    catch
        fprintf("[Recorder.start] Failed to make logdata.\n");
        obj.stop();
    end
    
    % Create loginfo structure
    try
        obj.loginfo = make.loginfo(obj.instruments, obj.schema);
    catch
        fprintf("[Recorder.start] Failed to make loginfo.\n");
        obj.stop();
    end
    
    % Add timer parametrs to info structure.
    % Do not do this: parameters = fieldnames(obj.logger);
    parameters = {'Name', 'ExecutionMode', ...
        'Period', 'AveragePeriod', 'InstantPeriod', ...
        'TasksToExecute', 'TasksExecuted'};
    for j = 1:numel(parameters)
        parameter = parameters{j};
        obj.loginfo.timer.(parameter) = obj.logger.(parameter);
    end
    
    % Reset counter
    obj.cnt = 0;
end