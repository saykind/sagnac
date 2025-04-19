function logStep(obj, event)
    %Timer step function
    %   Records datapoint, and periodically saves data.
    %   Frequency for each operation is specified in obj.rate.
    step_time = event.Data.time;
    step_time = datetime(step_time, 'Format', 'HH:mm:ss');
    cnt = obj.logger.TasksExecuted;

    % Record datapoint
    try
        obj.log();
    catch
        util.msg("Failed to record datapoint.");
        obj.stop();
    end

    % Update timer info
    obj.loginfo.timer.TasksExecuted = cnt;

    % Plot data
    plot_rate = 1;
    if ~isempty(obj.graphics) && isgraphics(obj.graphics.figure) && (rem(cnt, plot_rate) > plot_rate-2)
        try
            pull.(obj.seed).plot(obj.graphics, obj.logdata);
        catch
            util.msg("Failed to plot.");
            obj.stop();
        end
    end
    
    % Save data
    save_rate = 100;
    if (rem(cnt, save_rate) > save_rate-2)
        try
            obj.save(obj.loginfo.filename);
        catch
            util.msg("Failed to save.");
            obj.stop();
        end
    end
    
    % Print timer info
    if obj.verbose == inf
        fprintf('[%s] (%s) completed %d steps.\n', obj.seed, step_time, cnt);
    end
end