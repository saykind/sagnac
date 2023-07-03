function logStep(obj, event)
    %Timer step function
    %   Records datapoint, plots data, saves data, and make a sweep step.
    %   Frequency for each operation is specified in obj.rate.
    
    obj.cnt = obj.cnt + 1;
    
    try
        if ~isempty(obj.sweep) && (rem(obj.cnt, obj.sweep.rate) > obj.sweep.rate-2)
            make.sweep(obj.key, obj.instruments, obj.sweep, obj.cnt+2*obj.sweep.rate);
            obj.rec = 0;
            if obj.verbose > 99, fprintf("[%s] rec=%d\n", obj.title, obj.rec); end
        end
        if ~isempty(obj.sweep) && (rem(obj.cnt+2*obj.sweep.rate-obj.sweep.pause, obj.sweep.rate) > obj.sweep.rate-2)
            obj.rec = 1;
            if obj.verbose > 99, fprintf("[%s] rec=%d\n", obj.title, obj.rec); end
        end
    catch
        fprintf("[Recorder.step] Failed to do a sweep step.");
    end

    % Record datapoint
    if obj.rec == 1
        try
            obj.record();
            if obj.verbose > 49, fprintf("[%s] recorded.\n", obj.title); end
        catch
            fprintf("[Recorder.step] Failed to record datapoint. ");
            fprintf("Counter = %d\n", obj.cnt);
            obj.stop();
        end
    end
    
    % Save data
    if (rem(obj.cnt, obj.rate.save) > obj.rate.save-2)
        obj.save(event);
    end
    
    % Plot data
    if (rem(obj.cnt, obj.rate.plot) > obj.rate.plot-2)
        if ~isempty(obj.graphics) && isgraphics(obj.graphics.figure)
            make.graphics(obj.key, obj.graphics, obj.logdata);
        end
        if obj.verbose > 59, fprintf("[%s] plotted.\n", obj.title); end
    end
    
    % Print timer info
    if obj.verbose == inf
        fprintf('[%s] %s taks %d\n', obj.title, ...
            datestr(event.Data.time, 'HH:MM:SS'), obj.cnt);
    end
    
    
end