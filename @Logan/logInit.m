function logInit(obj)
    obj.logger = timer('Tag', 'Rec', 'Period', 1, 'TasksToExecute', Inf, 'ExecutionMode', 'fixedRate');
    obj.logger.Name = ['Rec-', obj.logger.Name];
    obj.logger.StartFcn = @(~, event)obj.logStart(event);
    obj.logger.TimerFcn = @(~, event)obj.logStep(event);
    obj.logger.StopFcn = @(~, event)obj.logStop(event);
    obj.logger.ErrorFcn = @(~, event)obj.logError(event);
end