function logError(obj, event)
    %Timer error function
    if ~isempty(obj.logger)
        obj.stop();
    end
end