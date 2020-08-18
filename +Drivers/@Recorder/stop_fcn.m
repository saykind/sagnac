function obj = stop_fcn(obj, thisEvent)
    %Timer stop function
    disp(['Measurement stopped: ' ...
        datestr(thisEvent.Data.time, 'dd-mmm-yyyy HH:MM:SS')]);
    
    obj.save();
    fprintf("Data saved to %s.\n", obj.path);
end