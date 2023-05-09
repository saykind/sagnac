function logStep(obj, event)
    %Timer step function
    
    obj.cnt = obj.cnt + 1;
    
    if ~isempty(obj.sweep) && (rem(obj.cnt, obj.sweep.rate) > obj.sweep.rate-2)
        make.sweep(obj.key, obj.instruments, obj.sweep, obj.cnt+1+obj.sweep.rate);
        obj.rec = 0;
    end
    if ~isempty(obj.sweep) && (rem(obj.cnt-obj.sweep.pause, obj.sweep.rate) > obj.sweep.rate-2)
        obj.rec = 1;
    end
    if obj.rec == 1
        obj.record();
    end
    
    if (rem(obj.cnt, obj.rate.save) > obj.rate.save-2)
        obj.save(event);
    end
    
    if (rem(obj.cnt, obj.rate.plot) > obj.rate.plot-2)
        if ~isempty(obj.graphics) && isgraphics(obj.graphics.figure)
            make.graphics(obj.key, obj.graphics, obj.logdata);
        end
    end
    
    if obj.verbose == inf
        fprintf('[%s] %s taks %d\n', obj.title, ...
            datestr(event.Data.time, 'HH:MM:SS'), obj.cnt);
    end
    
    
end