function obj = StopFcn(obj, event)
    %Timer stop function

    obj.instruments_clear();
    obj.SaveFcn(event);
    fprintf('[%s] stopped (%s).\n', obj.title, ...
        datestr(event.Data.time, 'dd-mmm-yyyy HH:MM:SS'));
end