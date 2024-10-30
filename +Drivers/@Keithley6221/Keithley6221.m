classdef (Sealed = true) Keithley6221 < Drivers.Device
    %Driver for Keithley 2401 Source meter
    %   Release date: July 2023
    %   This class was created in Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru)
    %
    %   Matlab 2018b or higher is required.
    %   The following packages are used:
    %   - Instrument Control Toolbox
    %
    %
    %   Usage example:
    %   source = Drivers.Keithley6621(25);
    %   source.set('v', 1);
    %   v = voltmeter.get('v');
    
    properties
        
        % Instrument Parameters
        on;                             %   output state
        compliance;                     %   compliance voltage
        current;                        %   applied current
        
        % Ramping parameters
        ramper;
        rampInfo;
    end
    
    methods
        function obj = Keithley6221(varargin)
            %Keithley2401 class constructor class
            obj.interface = "gpib";
            obj = obj.init(varargin{:});
            obj.rename("Keithley6221");
            
            obj.fields = {};
            fieldsUnits = {};
            obj.parameters = {'on', 'compliance', 'current'};
            parametersUnits = {'', 'V', 'A'};
            units = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(units{:});
        end

        apply(obj, I1, rate, period)

        % Getters (Parameters)
        function o = get.on(obj), o = obj.get('on'); end
        function c = get.compliance(obj), c = obj.get('compliance'); end
        function c = get.current(obj), c = obj.get('current'); end

        % Setters (Parameters)
        function set.on(obj, o), obj.set('on', o); end
        function set.compliance(obj, c), obj.set('compliance', c); end
        function set.current(obj, c), obj.set('current', c); end

        % Display parameters
        function disp(obj)
            fprintf("Keithley 6221 Current Source\n");
            fprintf("  GPIB Address: %d\n", obj.address);

            fprintf("  Output: %d\n", obj.on);
            fprintf("  Compliance: %f V\n", obj.compliance);
            fprintf("  Current: %f A\n", obj.current);
        end

        % Apply (current ramp)
        function applyStart(obj, ~)
            obj.on = 1;
        end
        
        function applyStep(obj, ~)
            try
                i = obj.ramper.TasksExecuted;
                obj.set('current', obj.rampInfo.I_array(i));
            catch ME
                util.msg(ME.message);
            end
        end
        
        function applyStop(obj, ~)
            if obj.rampInfo.I_final == 0
                obj.on = 0;
            end
        end
        
    end
end

