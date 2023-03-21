classdef (Sealed = true) Recorder < handle
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
    %   experiment = Recorder('hall');
    %   experiment.start();
    
    properties
        title;                      %   Name of the experiment
        readme;                     %   Experiment description
        info;                       %   Intrument parameters
        
        schema;                     %   Instrument configuration
        instruments;                %   Structure with instrument handles
        
        foldername;                 %   Path to folder with datafiles
        filename;                   %   Path to data.mat file
        
        logdata;                    %   Main data structure
        
        timer;                      %   Timer object
    end
    
    methods
        function obj = Recorder(seed)
            %Construct an instance of this class
            %   seed char creates pre-defined experiment setups:
            %       'r' -   transport (single SR830 lockin)
            %       't' -   transport (two SR830 lockins)
            %       'T' -   temperature (LSCI331)
            %       'k' -   Kerr (SR844)
            %       'K' -   Kerr & transport
            %       'A' -   all available instruments
            
            obj.timer = timer;
            obj.timer.Period = 1;
            obj.timer.TasksToExecute = inf;
            obj.timer.ExecutionMode = 'fixedRate';
            obj.timer.StartFcn = @(~, event)obj.StartFcn(event);
            obj.timer.TimerFcn = @(~, event)obj.TimerFcn(event);
            obj.timer.StopFcn = @(~, event)obj.StopFcn(event);
            
            obj.logdata = struct();
            obj.instruments = struct();
            obj.init(seed);
        end
    end
    
    methods(Sealed)
        init(obj, seed);
        function instruments_clear(obj), obj.instruments = struct(); end
        function instruments_init(obj)
            obj.instruments_clear();
            obj.instruments = Recorder.make_instruments(obj.schema);
        end
        function start(obj),  obj.timer.start(); end
        function stop(obj),   obj.timer.stop(); end
        StartFcn(obj, event);
        TimerFcn(obj, event);
        StopFcn(obj, event);
        SaveFcn(obj, event);    %Non-timer function
        datapoint(obj);
    end
    
    methods(Static)
        filename = make_filename(foldername);
        schema = make_schema(seed);
        instruments = make_instruments(schema);
        info = make_info(instruments, schema);
        logdata = make_logdata(instruments, schema);
        function event = print_event(event), disp(event); end
    end
end



