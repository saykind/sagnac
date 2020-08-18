function obj = start(obj, totalTime, timeStep)
    %Write data to obj.path file
    
    if nargin < 2
        fprintf('Total run time must be specified\n');
        return
    end
    obj.totalTime = totalTime;
    
    if isvalid(obj.timer) && strcmp(obj.timer.Running, 'on')
        disp("Timer is already running.")
        return
    end
    
    if nargin < 3
        timeStep = obj.timeStep;
    end
    
    % Calculate total number of time steps
    totalSteps = round(totalTime/obj.timer.Period);
    obj.totalSteps = totalSteps;
    
    % Configure timer
    obj.timer.Period = timeStep;
    obj.timer.TasksToExecute = totalSteps;
    
    % Preallocate memory for logdata
    obj.data.logdata.time = zeros(1,totalSteps);
    for instrumentCell = obj.instruments
        instrument = instrumentCell{1};
        for field = instrument.fields
            obj.data.logdata.(instrument.idn).(field{:}) = zeros(1,totalSteps);
        end
    end
    
    % Start the timer
    start(obj.timer);
end