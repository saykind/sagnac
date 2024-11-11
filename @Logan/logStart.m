function logStart(obj, event)
%LOGSTART Timer (logger) start function.

    % Check that instruments and schema exist.
    if isempty(obj.instruments), util.msg("Instruments are missing."); return; end
    if isempty(obj.schema), util.msg("Schema is missing."); return; end

    start_time = event.Data.time;

    % Make data filename
    obj.loginfo.filename = util.filename.new( ...
        datetime = event.Data.time, ...
        appendix = ['_', obj.seed{:}]);
    
    % Add timer parametrs to info structure.
    % Do not do this: parameters = fieldnames(obj.logger);
    obj.loginfo.timer = struct();
    parameters = {'Name', 'ExecutionMode', ...
        'Period', 'AveragePeriod', 'InstantPeriod', ...
        'TasksToExecute', 'TasksExecuted'};    
    for j = 1:numel(parameters)
        parameter = parameters{j};
        obj.loginfo.timer.(parameter) = obj.logger.(parameter);
    end
    obj.loginfo.timer.StartTime = start_time;

    % Print start message
    start_time = datetime(start_time, 'Format', 'HH:mm:ss');
    if obj.verbose
        fprintf('[%s] (%s) started.\n', obj.seed, start_time);
        obj.etc();
    end
end