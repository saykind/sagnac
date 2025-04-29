function s = etc(obj)
%ETC Estimate time of completion
    if obj.logger.TasksToExecute < inf
        duration = obj.logger.Period*seconds(obj.logger.TasksToExecute);
        duration = duration + seconds(obj.logger.StartDelay);
        stopTime = datetime(obj.loginfo.timer.StartTime) + duration;
        stopTime = datetime(stopTime, 'Format', 'dd-MMM-yyyy HH:mm:ss');
    else
        stopTime = '+inf';
    end
    s = sprintf('[%s] estimated time of completion: %s.\n', obj.seed, stopTime);
    fprintf(s);
end