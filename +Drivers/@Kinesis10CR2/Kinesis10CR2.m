classdef Kinesis10CR2 < Drivers.Device
%Kinesis10CR2 instrument driver for Thorlabs K10CR2 cage rotation mount.
%   Release date: November, 2024.
%
%   Usage example:
%   obj = Drivers.Kinesis10CR2();



    properties
        % Instrument Parameters
        serial_num = '55475864';
        timeout = 60000;
        motorSettings;
        currentDeviceSettings;
        deviceUnitConverter;
        
        % Instrument Fields
        angle;                   %   deg
    end
    
    methods
        function obj = Kinesis10CR2(varargin)
            obj.interface = "Kinesis10CR2";
            obj.rename("Kinesis10CR2");

            obj.init();
            
            obj.fields = {'angle'};
            fieldsUnits = {'deg'};
            obj.parameters = {};
            parametersUnits = {};
            units_ = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(units_{:});
            
            %obj.update();
        end

        % Methods (inherited)
        init(obj);

        % Getters
        function a = get.angle(obj), a = obj.get('angle'); end

        % Setters
        function set.angle(obj, a), obj.set('angle', a); end
    end
end