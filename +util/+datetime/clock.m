function timeArray = clock()
% MATLAB suggests using datetime() instead of clock() for new code
% This function is a wrapper for datetime() that returns the same output as clock()

    % Get current date and time as a datetime object
    currentDateTime = datetime("now");
    
    % Extract components to match the output of clock()
    timeArray = [year(currentDateTime), ...
                 month(currentDateTime), ...
                 day(currentDateTime), ...
                 hour(currentDateTime), ...
                 minute(currentDateTime), ...
                 second(currentDateTime)];
end