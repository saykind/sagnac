classdef Colin < handle
%Colin Superclass for data collection (acquisition).
%   COLIN is able to intialize experiment scheme, create instrument intefaces, 
%   log (record) single data point from each instrument, and save data to file.

    properties
        seed;                   %   String, experiment identifyer
        comment;                %   String, user provided experiment description

        schema;                 %   Instrument configuration table
        instruments;            %   Structure with instrument objects
                                %   Each instrument object should have a get() method.

        logdata;                %   Main data structure
        loginfo;                %   Configuration information structure

        verbose;                %   Verbosity level
    end
    
    methods
        function obj = Colin(seed, instr)
            if ~nargin, error('Seed must be provided.'); end
            [seed, comment] = Colin.parse(seed); 
            obj.seed = seed;
            obj.comment = comment;
            obj.verbose = 1;
            obj.schema = pull.schema(obj.seed);
            if nargin > 1, obj.inin(instr); end
            return;
        end
        
        log(obj);                   %   Record single datapoint from each istrument
        save(obj, filename);        %   Write logdata and loginfo to file
        instr = inin(obj, instr)    %   Instrument initialization function
    end

    methods(Static)
        [seed, comment] = parse(seed);
    end
end