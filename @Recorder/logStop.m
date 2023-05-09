function logStop(obj, event)
    %Timer stop functio
    obj.save(event);
    if obj.verbose
        fprintf('[%s] stopped (%s).\n', obj.title, ...
            datestr(event.Data.time, 'dd-mmm-yyyy HH:MM:SS'));
    end
end