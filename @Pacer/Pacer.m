classdef Pacer < Logan

    properties
        schema;                 %   Instrument configuration table
        instruments;            %   Structure with instrument objects
                                %   Each instrument object should have a get() method.
        logdata;                %   Data structure
        verbose;                %   Verbosity level
    end
    
    methods
        function obj = Logan(varargin)
            if ~nargin, return, end
            obj = obj.init(varargin{:});
        end

        function start(obj), obj.loginit(); obj.logger.start(); end
        function stop(obj), obj.logger.stop(); obj.logclear(); end
        
        logclear(obj);
        loginit(obj);
        logstart(obj, event);
        logstep(obj, event);
        logstop(obj, event);
        logerror(obj, event);
        log(obj, event);
        save(obj, event);
        
    end
end