function obj = TimerFcn(obj, event)
    %Timer step function

    obj.datapoint();
    
    if (rem(obj.timer.TasksExecuted, 100) > 98)
        obj.SaveFcn(event);
    end
end