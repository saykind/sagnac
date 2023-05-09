function StepFcnSweep(obj, event)
    %Timer step function
    
    %fprintf('[sweeper] step (%s).\n', datestr(event.Data.time, 'dd-mmm-yyyy HH:MM:SS'));
    
    parameter = obj.range(obj.cntSweep);
    fprintf("[sweeper] Magnet Current = abs(%.2f) A.\n", parameter);
    obj.instruments.magnet.set('I', abs(parameter));
    
    if parameter < 0
        obj.polarity = -1;
    else
        obj.polarity = 1;
    end
    
    if parameter == 0
        sound(sin(1:5000));
        input("Is magnet in correct polarity? Press return to continue.", "s");
    end
    
    obj.cntSweep = obj.cntSweep + 1;
end