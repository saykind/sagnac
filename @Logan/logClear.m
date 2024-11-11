function logClear(obj)
%LOGCLEAR Deletes the logger object.

    try
        isvalid(obj.logger);
    catch
        util.msg("logger property is not a handle.\n");
        return
    end

    if ~isvalid(obj.logger)
        util.msg("logger object is invalid.\n");
        return
    end

    if strcmp(obj.logger.Running, 'on')
        obj.logger.stop();
        fprintf([obj.logger.Name, ' stopped.\n']);
    end

    fprintf([obj.logger.Name, ' deleted.\n']);
    delete(obj.logger);
    obj.logger = [];
end