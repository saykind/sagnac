classdef (Sealed = true) Recorder < handle
    %Kerr agnle data recorder class
    %   Release August 5, 2020 (v1.0)
    %
    %   This class was created for anlysis of Sagnac interferometer data in
    %   Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru)
    %
    %   Matlab 2019b or higher is required.
    %   The following packages are used:
    %   - Instrument Control Toolbox
    %
    %
    %   Usage example:
    %   rec = Sagnatron.Analyser();
    %   rec.start(1000);
    
    properties
        instrumentStructure;        %   Map to cell arrays of instrument objects
        instruments = {};           %   Intruments to record
        
        path;                       %   Path to data.mat file
        data;                       %   Main data structure
        
        firstAxes;                  %   Handle to the first harmonic axes
        secondAxes;                 %   Handle to the second harmonic axes
        tempAxes;                   %   Handle to the temperature axes
        
        counter = 0;                %   Number of data points
        timer;                      %   Current timer object
        timeStep = 1;               %   Timer time step (default: 1 sec)
        totalTime = 5;              %   Total time of operation (sec)
        totalSteps = 5;             %   Total number of time steps
        
        startTime;                  %   Measurement start time
        currentTime;                %   Current time
        stopTime;                   %   Measurement stop time
    end
    
    methods
        function obj = Recorder(varargin)
            %Construct an instance of this class
            %   If present, the only argument shoud be either a path to 
            %   data.mat file or a logdata structure.
            
            % Find available insturments
            obj.instrumentStructure = Drivers.find_instruments(0);
            fn = fieldnames(obj.instrumentStructure);
            for i = 1:numel(fn)
                obj.instruments{end+1} = obj.instrumentStructure.(fn{i});
            end
            
            % Create and configure the timer
            obj.timer = timer;
            obj.timer.StartFcn = @(~, thisEvent)obj.start_fcn(thisEvent);
            obj.timer.TimerFcn = @(~, thisEvent)obj.timer_fcn(thisEvent);
            obj.timer.StopFcn = @(~, thisEvent)obj.stop_fcn(thisEvent);
            
            obj.timer.Period = obj.timeStep;
            obj.timer.TasksToExecute = round(obj.totalTime/obj.timer.Period);
            obj.timer.ExecutionMode = 'fixedRate';
        end
        
        obj = start(obj, totalTime, timeStep);
        obj = stop(obj);
        
        obj = save(obj);
        obj = read(obj);
        
        obj = start_fcn(obj, thisEvent);
        obj = timer_fcn(obj, thisEvent);
        obj = stop_fcn(obj, thisEvent);
        
        obj = sweep_pm(obj, varargin);
    end

end

