function logInit(obj)
    obj.logger = timer('Tag', 'Recorder');
    obj.loggerName = obj.logger.Name;
    obj.logger.Period = obj.rate.timer;
    if isempty(obj.sweep)
        obj.logger.TasksToExecute = inf;
        %obj.logger.TasksToExecute = 5e4;
    else
        r = obj.sweep.rate;
        n = length(obj.sweep.range);
        obj.logger.TasksToExecute = r*n-2;
    end
    obj.logger.ExecutionMode = 'fixedRate';
    obj.logger.StartFcn = @(~, event)obj.logStart(event);
    obj.logger.TimerFcn = @(~, event)obj.logStep(event);
    obj.logger.StopFcn = @(~, event)obj.logStop(event);
end