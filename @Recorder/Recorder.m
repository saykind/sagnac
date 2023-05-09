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
    %   experiment.stop();
    
    properties
        key;                        %   (numeric) pre-defined experiment id
        title;                      %   Name of the experiment
        seed;                       %   user-provided experiment id
        
        schema;                     %   Instrument configuration
        instruments;                %   Structure with instrument handles
        rate;                       %   Structure with action frequencies
        sweep;                      %   Structure with sweep info
        
        foldername;                 %   Path to folder with datafiles
        filename;                   %   Path to data.mat file
        
        loginfo;                    %   Intrument parameters
        logdata;                    %   Main data structure
        
        graphics;                   %   Handles to figure and axes
        
        logger;                     %   logging timer object
        loggerName;                 %   makes it possible to find timer
        cnt;                        %   Executed steps counter
        rec;                        %   Record flag
        
        verbose;                    %   Print info to the command line
                                    %       0:      No messages
                                    %       1:      Start/finish messages
                                    %       2:      Start/finish/save meassages
                                    %       inf:    All messages
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
            %       'p' -   Optical power
            %       'A' -   all available instruments
            obj.construct(seed);
        end
        
        construct(obj, seed);
        function i(obj), obj.instruments = make.instruments(obj.schema); end
        function g(obj), obj.graphics = make.graphics(obj.key); end
        function start(obj), obj.logInit(); obj.logger.start(); end
        function stop(obj), obj.logger.stop(); obj.logClear(); end
        logClear(obj);
        logInit(obj);
        logStart(obj, event);
        logStep(obj, event);
        logStop(obj, event);
        save(obj, event);
        record(obj);
    end
end



