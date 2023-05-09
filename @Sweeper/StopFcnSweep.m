function StopFcnSweep(obj, event)
    %Timer stop function

    fprintf('[sweeper] stop (%s).\n', datestr(event.Data.time, 'dd-mmm-yyyy HH:MM:SS'));
    
    obj.timer.stop();
    
    obj.instruments.magnet.set('I', 0, 'V', 12);
    obj.instruments.magnet.set('output', 'off');
end