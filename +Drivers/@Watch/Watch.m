classdef Watch < Drivers.Device
    %Fake driver used to record current time.
    %   Release date: November, 2024.
    %   This class was created in Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru).
    %
    %
    %   Usage example:
    %   obj = Drivers.Watch();
    %   obj.datetime;
    %   [c, dt] = tmr.get('c', 'dt'); 
    %   assert(second(dt)==c(6));
    
    properties
        % Instrument Fields
        datetime;                   %   Date and time in datetime format
        clock;                      %   Date and time in clock format (legacy)
    end
    
    methods
        function obj = Watch(varargin)
            obj = obj.init(varargin{:});
            obj.interface = "datetime";
            obj.rename("Watch");
            
            obj.fields = {'datetime'};
            fieldsUnits = {''};
            obj.parameters = {};
            parametersUnits = {};
            units_ = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(units_{:});
            
            obj.update();
        end

        % Getters
        function f = get.datetime(obj), f = obj.get('datetime'); end
        function c = get.clock(obj), c = obj.get('clock'); end

        % Methods (inherited)
        function obj = init(obj, ~, ~, varargin), end
    end
end

