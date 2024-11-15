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

        % Operation parameters
        velocity;                %   deg/s
        acceleration;            %   deg/s^2
        
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
            obj.parameters = {'velocity'};
            parametersUnits = {'deg/s'};
            units_ = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(units_{:});
            
            %obj.update();
        end

        % Methods (inherited)
        init(obj);

        % Getters
        function v = get.velocity(obj), v = obj.get('velocity'); end
        function acc = get.acceleration(obj), acc = obj.get('acceleration'); end
        function a = get.angle(obj), a = obj.get('angle'); end

        % Setters
        function set.velocity(obj, v), obj.set('velocity', v); end
        function set.acceleration(obj, acc), obj.set('acceleration', acc); end
        function set.angle(obj, a), obj.set('angle', a); end

        % Custom methods
        function blink(obj)
            % Blink the LED on the device 5 times.
            obj.handle.IdentifyDevice();
        end
    end
end