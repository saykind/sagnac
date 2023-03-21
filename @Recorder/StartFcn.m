function obj = StartFcn(obj, event)
    %Timer start function
    
    if isempty(obj.schema)
        fprintf("[%s] instrument SCHEMA is required.\n", obj.title);
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
   
    obj.instruments = Recorder.make_instruments(obj.schema);
    obj.logdata = Recorder.make_logdata(obj.instruments, obj.schema);
    obj.info = Recorder.make_info(obj.instruments, obj.schema);
    
    % Add timer parametrs to info structure.
    parameters = filednames(obj.timer);
    for j = 1:numel(parameters)
        parameter = parameters{j};
        obj.info.timer.(parameter) = obj.timer.parameter;
    end
end