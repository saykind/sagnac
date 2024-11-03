classdef Manual < Drivers.Device
    %Fake driver used to record manual data entry.
    %   Release date: November, 2024.
    %   This class was created in Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru).
    %
    %
    %   Usage example:
    %   obj = Drivers.Manual();
    
    properties
        % Instrument Fields
        position;                   %   um, position of the stage
    end
    
    methods
        function obj = Manual(varargin)
            obj = obj.init(varargin{:});
            obj.interface = "";
            obj.rename("Manual");

            obj.position = NaN;
            
            obj.fields = {'position'};
            fieldsUnits = {'thou'};
            obj.parameters = {};
            parametersUnits = {};
            units_ = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(units_{:});
            
            obj.update();
        end

        % Methods (inherited)
        function obj = init(obj, ~, ~, varargin), end
    end
end

