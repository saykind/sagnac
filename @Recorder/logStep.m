function logStep(obj, event)
    %Timer step function
    %   Records datapoint, plots data, saves data, and make a sweep step.
    %   Frequency for each operation is specified in obj.rate.
    
    % Pre-set instrument parameters.
    if obj.cnt == 0
        try
            if ~isempty(obj.sweep)
                make.sweep(obj.key, obj.instruments, obj.sweep);
                obj.rec = 0;
                if obj.verbose > 99, fprintf("[%i] rec=%d\n", obj.key, obj.rec); end
            end
        catch
            fprintf("[Recorder.start] Failed to preset instruments.\n");
            obj.stop();
        end
    end
    
    obj.cnt = obj.cnt + 1;
    %disp(event.Data);
    try
        if ~isempty(obj.sweep) && (rem(obj.cnt, obj.sweep.rate) > obj.sweep.rate-2)
            make.sweep(obj.key, obj.instruments, obj.sweep, obj.cnt+2*obj.sweep.rate);
            obj.rec = 0;
            if obj.verbose > 99, fprintf("[%i] rec=%d\n", obj.key, obj.rec); end
        end
        if ~isempty(obj.sweep) && (rem(obj.cnt+2*obj.sweep.rate-obj.sweep.pause, obj.sweep.rate) > obj.sweep.rate-2)
            obj.rec = 1;
            if obj.verbose > 99, fprintf("[%i] rec=%d\n", obj.key, obj.rec); end
        end
    catch
        fprintf("[Recorder.step] Failed to do a sweep step.\n");
    end

    % Record datapoint
    if obj.rec == 1
        try
            obj.record();
            if obj.verbose > 49, fprintf("[%i] recorded.\n", obj.key); end
        catch
            fprintf("[Recorder.step] Failed to record datapoint. ");
            fprintf("Counter = %d\n", obj.cnt);
            obj.stop();
        end
    end
    
    % Save data
    if (rem(obj.cnt, obj.rate.save) > obj.rate.save-2)
        try
            obj.save(event);
        catch
            fprintf("[Recorder.step] Failed to save. ");
            fprintf("Counter = %d\n", obj.cnt);
            obj.stop();
        end
    end
    
    % Plot data
    if (rem(obj.cnt, obj.rate.plot) > obj.rate.plot-2)
        if ~isempty(obj.graphics) && isgraphics(obj.graphics.figure)
            make.graphics(obj.key, obj.graphics, obj.logdata);
        end
        if obj.verbose > 59, fprintf("[%i] plotted.\n", obj.key); end
    end
    
    % Print timer info
    if obj.verbose == inf
        fprintf('[%i] %s taks %d\n', obj.key, ...
            datestr(event.Data.time, 'HH:MM:SS'), obj.cnt);
    end
    
    
end