function logStop(obj, event)
%LOGSTOP Timer stop function

    stop_time = event.Data.time;
    stop_time = datetime(stop_time, 'Format', 'HH:mm:ss');

    obj.save(obj.loginfo.filename);
    
    % Print stop message
    if obj.verbose
        fprintf('[%s] (%s) stopped.\n', obj.seed, stop_time);
    end
end