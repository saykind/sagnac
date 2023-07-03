function logStop(obj, event)
    %Timer stop function
    if ~isempty(obj.graphics), obj.plot(); end
    obj.save(event);
    if obj.verbose
        fprintf('[%s] stopped (%s).\n', obj.title, ...
            datestr(event.Data.time, 'dd-mmm-yyyy HH:MM:SS'));
        if obj.verbose > 9, sound(sin(1:5000)); end
    end
end