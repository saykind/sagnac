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
    %   experiment = Recorder('k : Kerr Effect, Material');
    %   experiment.start();
    %   experiment.stop();
    
    properties
        seed;                       %   User-provided experiment id
        key;                        %   Numeric experiment id
        title;                      %   Name of the experiment
                
        schema;                     %   Instrument configuration
        instruments;                %   Structure with instrument handles
        rate;                       %   Structure with action frequencies
        sweep;                      %   Structure with sweep info
        
        foldername;                 %   Path to folder with datafiles
        filename;                   %   Path to data.mat file
        
        loginfo;                    %   Intrument parameters
        logdata;                    %   Main data structure
        
        graphics;                   %   Handles to figure and axes
        
        logger;                     %   Logging timer object
        loggerName;                 %   Makes it possible to find timer
        cnt;                        %   Executed steps counter
        rec;                        %   Record flag
        
        verbose;                    %   Print info to the command line
                                    %       0:      No messages
                                    %       1:      Start/finish msg
                                    %       2:      Start/finish/save msg
                                    %       10:     Sounds
                                    %       inf:    All messages
    end
    
    methods
        function obj = Recorder(seed)
            %Construct an instance of this class
            %   Seed char creates pre-defined experiment setups.
            %
            %   Examples:
            %       r = Recorder("kerr")
            %       r = Recorder("transport")
            %       r = Recorder("tk : time vs kerr")
            %
            %   See also:
            %       make.key();
            %       make.title();
            obj.construct(seed);
        end
        
        construct(obj, seed);
        function i(obj), obj.instruments = make.instruments(obj.schema); end
        function g(obj), obj.graphics = make.graphics(obj.key); end
        function start(obj), obj.logInit(); obj.logger.start(); end
        function stop(obj), obj.logger.stop(); obj.logClear(); end
        function plot(obj) 
            if isempty(obj.graphics) || ~isgraphics(obj.graphics.figure)
                obj.g();
            end
            make.graphics(obj.key, obj.graphics, obj.logdata);
        end
        logClear(obj);
        logInit(obj);
        logStart(obj, event);
        logStep(obj, event);
        logStop(obj, event);
        save(obj, event);
        record(obj);
    end
end



