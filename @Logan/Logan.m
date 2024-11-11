classdef Logan < Colin
%LOGAN Class for data acquisition using a timer.
%   LOGAN uses timer object to record data from instruments at a fixed rate.
%
%   See also: COLIN
    properties
    % Parent properties:
    %   seed;                   -   String, experiment identifyer
    %   comment;                -   String, user provided experiment description
    %   schema;                 -   Instrument configuration table
    %   instruments;            -   Structure with instrument objects
    %   logdata;                -   Main data structure
    %   loginfo;                -   Configuration information structure
    %   verbose;                -   Verbosity level
        graphics;               %   Structure with figure and axes handles
        logger;                 %   Timer object
    end

    methods
        function obj = Logan(varargin)
            obj = obj@Colin(varargin{:});
        end
        
        logInit(obj);
        logStart(obj, event);
        logStep(obj, event);
        logStop(obj, event);
        logError(obj, event);
        logClear(obj);
        etc(obj);

        function start(obj), obj.logInit(); obj.logger.start(); end
        function stop(obj), obj.logger.stop(); obj.logClear(); end
    end
end
