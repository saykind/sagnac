function logError(obj)
%LOGERROR Timer error function

    if isfield(obj.instruments, 'source')
        disp('Ramping source to 0 V.');
        obj.instruments.source.ramp(0,.2);
    end

    error_time = datetime('now', 'Format', 'HH:mm:ss');

    % Print error message
    if obj.verbose
        fprintf('[%s] (%s) error.\n', obj.seed, error_time);
    end

    obj.stop();
end