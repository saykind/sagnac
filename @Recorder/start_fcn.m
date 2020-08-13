function obj = start_fcn(obj, thisEvent)
    %Timer start function
    obj.counter = 0;
    date = datestr(thisEvent.Data.time, 'yyyy-mm-dd_HH-MM');
    obj.path = fullfile(pwd(), date + ".mat");
    
    startTime = thisEvent.Data.time;
    obj.startTime = startTime;
    stopTime = datetime(startTime) + seconds(obj.totalTime);
    obj.stopTime = datevec(stopTime);
    
    disp(['Measurement started: ', ...
        datestr(startTime, 'dd-mmm-yyyy HH:MM:SS'), ...
        '\t(ETC:', datestr(stopTime, 'dd-mmm-yyyy HH:MM:SS'), ')']);

end