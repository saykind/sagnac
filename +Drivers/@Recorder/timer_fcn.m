function obj = timer_fcn(obj, thisEvent)
    %Timer action function
    obj.counter = obj.counter + 1;
    obj.currentTime = thisEvent.Data.time;
    obj.read();
end