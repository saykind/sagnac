function logError(obj, event)
    %Timer error function
    if ~isempty(obj.logger)
        obj.stop();
    end
    if isfield(obj.instruments, 'source')
        disp('Ramping source to 0 V.');
        obj.instruments.source.ramp(0,.2);
    end
end