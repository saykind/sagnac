classdef (Sealed = true) Sweeper < handle
    %A little instrument control environment
    %   Release March, 2023 (v1.0)
    %
    %   This class was created for recording of Sagnac interferometer data
    %   in Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru)
    %
    %   Matlab 2019b or higher is required.
    %   The following packages are used:
    %   - Instrument Control Toolbox
    %
    %
    %   Usage example:
    %   experiment = Sweeper('hall');
    %   experiment.start();
    %   experiment.stop();
    
    properties
        key;                        %   (numeric) pre-defined experiment id
        title;                      %   Name of the experiment
        seed;                       %   user-provided experiment id
        
        schema;                     %   Instrument configuration
        instruments;                %   Structure with instrument handles
        
        foldername;                 %   Path to folder with datafiles
        filename;                   %   Path to data.mat file
        saveRate;                   %   Save to file every # datapoints
        
        loginfo;                    %   Intrument parameters
        logdata;                    %   Main data structure
        
        graphics;                   %   Handles to figure and axes
        plotRate;                   %   Plot every # datapoints.
        
        timer;                      %   Log Timer object
        timerSweep;                 %   Sweep Timer object
        cnt;                        %   Executed steps counter
        cntSweep;                   %   Executed sweep steps counter
        
        range;                      %   Sweep range
        polarity;                   %   Magnet polarity
    end
    
    methods
        function obj = Sweeper(seed, range)
            %Construct an instance of this class
            %   seed char creates pre-defined experiment setups:
            %       'r' -   transport (single SR830 lockin)
            %       't' -   transport (two SR830 lockins)
            %       'T' -   temperature (LSCI331)
            %       'k' -   Kerr (SR844)
            %       'K' -   Kerr & transport
            %       'A' -   all available instruments

            % Make seed from key
            obj.key = 0;
            if nargin
                obj.seed = seed;
                obj.key = Sweeper.make_key(seed); 
            end
            if nargin < 2
                rangeAmplitude = .5;
                rangeStep = .02;
                rangeShift = .01;
                range = 0:rangeStep:rangeAmplitude;
                range = [range, (rangeAmplitude-rangeShift):(-rangeStep):0];
                range = [range, -1*range, 0];
            end
            obj.range = range;
            
            % Initialize parameters with default values
            obj.title = Sweeper.make_title(obj.key);
            obj.schema = Sweeper.make_schema(obj.key);
            obj.foldername = "data";
            obj.instruments = struct([]);
            obj.loginfo = struct([]);
            obj.logdata = struct([]);
            obj.graphics = struct([]);
            obj.cnt = 0;
            obj.plotRate = 1;
            obj.saveRate = 20;
            obj.polarity = 1;
        end
        function delete(obj)
            fprintf("[Sweeper] destructed.\n");
            if ~isempty(obj.timer)
                obj.timer_clear();
            end
            if ~isempty(obj.timerSweep)
                obj.timerSweep_clear();
            end
        end
    end
    
    
    methods(Sealed)
        function timer_clear(obj)
            try 
                isvalid(obj.timer);
            catch
                fprintf("[Sweeper] timer property is not a handle.\n");
                return
            end
            if ~isvalid(obj.timer)
                fprintf("[Sweeper] timer object is invalid.\n");
                return
            end
            if strcmp(obj.timer.Running, 'on')
                fprintf([obj.timer.Name, ' stopped.\n']);
                obj.timer.stop();
            end
            fprintf([obj.timer.Name, ' deleted.\n']);
            delete(obj.timer);
            obj.timer = [];
        end
        function timerSweep_clear(obj)
            try 
                isvalid(obj.timerSweep);
            catch
                fprintf("[Sweeper] timer property is not a handle.\n");
                return
            end
            if ~isvalid(obj.timerSweep)
                fprintf("[Sweeper] timer object is invalid.\n");
                return
            end
            if strcmp(obj.timerSweep.Running, 'on')
                fprintf([obj.timerSweep.Name, ' stopped.\n']);
                obj.timerSweep.stop();
            end
            fprintf([obj.timerSweep.Name, ' deleted.\n']);
            delete(obj.timerSweep);
            obj.timerSweep = [];
        end
        function timer_init(obj, period)
            if nargin < 2, period = 3; end
            obj.timer = timer('Tag', 'Sweeper');
            obj.timer.Period = period;
            obj.timer.TasksToExecute = inf;
            obj.timer.ExecutionMode = 'fixedRate';
            obj.timer.StartFcn = @(~, event)obj.StartFcn(event);
            obj.timer.TimerFcn = @(~, event)obj.StepFcn(event);
            obj.timer.StopFcn = @(~, event)obj.StopFcn(event);
        end
        function timerSweep_init(obj, period, startDelay)
            if nargin < 2, period = 9; end
            if nargin < 3, startDelay = 1; end
            obj.timerSweep = timer('Tag', 'Sweeper');
            obj.timerSweep.StartDelay = startDelay;
            obj.timerSweep.Period = period;
            obj.timerSweep.TasksToExecute = numel(obj.range);
            obj.timerSweep.ExecutionMode = 'fixedRate';
            obj.timerSweep.StartFcn = @(~, event)obj.StartFcnSweep(event);
            obj.timerSweep.TimerFcn = @(~, event)obj.StepFcnSweep(event);
            obj.timerSweep.StopFcn = @(~, event)obj.StopFcnSweep(event);
        end
        function instruments_clear(obj), obj.instruments = struct([]); end
        function instruments_init(obj)
            obj.instruments_clear();
            obj.instruments = Sweeper.make_instruments(obj.schema);
        end
        function graphics_clear(obj), obj.graphics = struct([]); end
        function graphics_init(obj)
            obj.graphics_clear();
            obj.graphics = Sweeper.make_graphics(obj.key);
        end
        function start(obj)
            obj.timer_init(6);
            obj.timer.start();
            obj.timerSweep_init(30, 1);
            obj.timerSweep.start();
        end
        function stop(obj)
            obj.timer.stop();
            obj.timer_clear();
        end
        function stopSweep(obj)
            obj.timerSweep.stop();
            obj.timerSweep_clear();
            obj.timer_clear();
        end
        StartFcn(obj, event);
        StepFcn(obj, event);
        StopFcn(obj, event);
        SaveFcn(obj, event);    %Non-timer function
        datapoint(obj);
    end
    
    methods(Static)
        %Information
        filename = make_filename(foldername);
        key = make_key(seed);
        title = make_title(key);
        %Instruments and data
        schema = make_schema(key);
        instruments = make_instruments(schema);
        loginfo = make_loginfo(instruments, schema);
        logdata = make_logdata(instruments, schema);
        %Graphics
        graphics = make_graphics(key);
        graphics = make_plot(key, graphics, logdata);
        plot(filename); %browse for data, plot and save.
        %Misc
        function s = datetimeToSeconds(d)
            s = dot((d(3:end).*[24*60*60 60*60 60 1]),[1 1 1 1]);
        end
        DeleteAllTimers(verbose);
    end
end



