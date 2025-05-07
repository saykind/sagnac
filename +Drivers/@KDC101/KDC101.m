classdef KDC101 < Drivers.Device
%KDC101 instrument driver for Thorlabs KDC101 K-cube.
%   Release date: April, 2025.
%
%   Documentation: Thorlabs.MotionControl.DotNET_API.chm
%   Under the contents tab you want to click on the very last index called “Classes” 
%   from there we want to go to 
%   Class List → Thorlabs → MotionControl → GenericMotorCLI → AdvancedMotor → GenericAdvancedMotorCLI 
%   which will have about 90% of the available methods.
%
%   Usage example:
%   obj = Drivers.KDC101();



    properties
        % Instrument Parameters
        serial_num = 27006514;
        timeout = 60000;
        motorSettings;
        motorConfiguration;
        currentDeviceSettings;
        deviceUnitConverter;

        % Operation parameters
        velocity;                %   mm/s
        acceleration;            %   mm/s^2
        backlash;                %   mm
        
        % Instrument Fields
        position;                %   mm
    end
    
    methods
        function obj = KDC101(serial_num)
            obj.interface = "KDC101";
            obj.rename("KDC101");
            obj.serial_num = serial_num;

            obj.init();
            
            obj.fields = {'position'};
            fieldsUnits = {'mm'};
            obj.parameters = {'velocity', 'acceleration', 'backlash'};
            parametersUnits = {'mm/s', 'mm/s^2', 'mm'};
            units_ = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(units_{:});
            
            %obj.update();
        end

        % Methods (inherited)
        init(obj);

        % Getters
        function vel = get.velocity(obj), vel = obj.get('velocity'); end
        function acc = get.acceleration(obj), acc = obj.get('acceleration'); end
        function b = get.backlash(obj), b = obj.get('backlash'); end
        function pos = get.position(obj), pos = obj.get('position'); end

        % Setters
        function set.velocity(obj, vel), obj.set('velocity', vel); end
        function set.acceleration(obj, acc), obj.set('acceleration', acc); end
        function set.backlash(obj, b), obj.set('backlash', b); end
        function set.position(obj, pos), obj.set('position', pos); end

        % Custom methods
        function blink(obj)
            % Blink the LED on the device 5 times.
            obj.handle.IdentifyDevice();
        end

        function home(obj, timeout)
            % Move the device to the home position.
            arguments
                obj
                timeout (1,1) double = obj.timeout
            end
            obj.handle.Home(timeout);
        end

        function stop(obj)
            % Stop the device.
            obj.handle.Stop();
        end
    end
end