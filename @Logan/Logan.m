classdef Logan < handle
% Superclass for data acquisition.
%   Logan is able to intialize experiment scheme, create instrument intefaces, 
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
        function obj = Logan(seed, instr)
            if ~nargin, error('Seed must be provided.'); end
            [seed, comment] = parse_seed(seed); 
            obj.seed = seed;
            obj.comment = comment;
            obj.verbose = 0;
            obj.schema = pull.schema(obj.seed);
            if nargin > 1, obj.inin(instr); end
            return;
        end
        
        log(obj);               %   Record single datapoint from each istrument
        save(obj, filename);    %   Write logdata and loginfo to file

        function instr_global = inin(obj, instr_global)
        % Instrument initialization function.
            arguments
                obj;
                instr_global struct = struct();
            end
            [instr, instr_global] = make.instruments(obj.schema, instr_global); 
            obj.instruments = instr;

            obj.logdata = pull.logdata(obj.instruments, obj.schema);
            obj.loginfo = pull.loginfo(obj.instruments, obj.schema);
        end
    end
end

function [seed, comment] = parse_seed(seed)
    if isstring(seed), seed = convertStringsToChars(seed); end
    if ischar(seed)
        seed = split(seed, ':');
        if isscalar(seed)            
            comment = "";
            seed = string(strip(seed{1}));
        else
            comment = strip(seed);
            seed = string(seed{1});
            comment = comment(2:end);
            comment = strcat(comment, "; ");
            comment = [comment{:}];
            comment = string(comment(1:end-2));
        end
    end
end