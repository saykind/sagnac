function StartFcnSweep(obj, event)
    %Timer start function
    
    fprintf('[sweeper] start (%s).\n', datestr(event.Data.time, 'dd-mmm-yyyy HH:MM:SS'));
    
    obj.instruments.magnet.set('I', 0, 'V', 12);
    obj.instruments.magnet.set('output', 'on');
    
    obj.cntSweep = 1;
end