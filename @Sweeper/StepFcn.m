function StepFcn(obj, event)
    %Timer step function
    
    %fprintf('[logger] step (%s).\n', datestr(event.Data.time, 'dd-mmm-yyyy HH:MM:SS'));
    
    obj.datapoint();
    
    if (rem(obj.cnt, obj.saveRate) > obj.saveRate-2)
        obj.SaveFcn(event);
        obj.instruments.lockinA.set('a', obj.loginfo.lockinA.amplitude);
        obj.instruments.lockinB.set('a', obj.loginfo.lockinB.amplitude);
    end
    
    if (rem(obj.cnt, obj.plotRate) > obj.plotRate-2)
        if ~isempty(obj.graphics) && isgraphics(obj.graphics.figure)
            Sweeper.make_plot(obj.key, obj.graphics, obj.logdata);
        end
    end
    
    obj.cnt = obj.cnt + 1;
end