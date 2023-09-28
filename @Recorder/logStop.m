function logStop(obj, event)
    %Timer stop function
    if ~isempty(obj.graphics), obj.plot(); end
    obj.save(event);
    if obj.verbose
        fprintf('[%i] stopped (%s).\n', obj.key, ...
            datestr(event.Data.time, 'dd-mmm-yyyy HH:MM:SS'));
        if obj.verbose > 9, sound(sin(1:5000)); end
    end
end