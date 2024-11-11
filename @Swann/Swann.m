classdef Swann < Logan
%SWANN Class for data acquisition during a sweep.
%   SWANN uses timer object to record data from instruments at a fixed rate.
%
%   See also: COLIN, LOGAN
    properties
    % Parent properties:
    %   seed;                   -   String, experiment identifyer
    %   comment;                -   String, user provided experiment description
    %   schema;                 -   Instrument configuration table
    %   instruments;            -   Structure with instrument objects
    %   logdata;                -   Main data structure
    %   loginfo;                -   Configuration information structure
    %   verbose;                -   Verbosity level
    %   logger;                 -   Timer object
        sweep;                  %   Information structure
    end

    methods
        function obj = Swann(varargin)
            obj = obj@Logan(varargin{:});
            obj.sweep = pull.(obj.seed).sweep();
        end

        function start(obj)
            obj.logdata = pull.logdata(obj.instruments, obj.schema);
            obj.sweep = pull.(obj.seed).sweep();
            obj.loginfo.sweep = obj.sweep;
            pull.(obj.seed).sweep(obj.instruments, obj.sweep);
            obj.logInit();
            obj.logger.TasksToExecute = numel(obj.sweep.points)-1;
            function step(obj, event)
                cnt = obj.logger.TasksExecuted;                
                if obj.sweep.record(cnt)
                    obj.logStep(event);
                end
                if obj.sweep.change(cnt)
                    pull.(obj.seed).sweep(obj.instruments, obj.sweep, cnt);
                end
            end
            obj.logger.TimerFcn = @(~, event) step(obj, event);
            obj.logger.start(); 
        end
    end
end
