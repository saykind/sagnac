function logInit(obj)
%LOGINIT Initializes the logger (timer) object.

    obj.logger = timer('Tag', 'Logan', ...
                       'Period', .5, ...
                       'TasksToExecute', Inf, ...
                       'ExecutionMode', 'fixedSpacing');
    obj.logger.Name = ['Logan-', obj.logger.Name];
    obj.logger.StartFcn = @(~, event)obj.logStart(event);
    obj.logger.TimerFcn = @(~, event)obj.logStep(event);
    obj.logger.StopFcn = @(~, event)obj.logStop(event);
    obj.logger.ErrorFcn = @(~, ~)obj.logError();

    % Create graphics
    obj.graphics = pull.(obj.seed).canvas();
end