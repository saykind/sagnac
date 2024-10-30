classdef (Sealed = true) Keithley2401 < Drivers.Device
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
    %   source = Drivers.Keithley2401(24);
    %   source.set('v', 1);
    %   v = voltmeter.get('v');
    
    properties
        
        % Instrument Parameters
        on;                             %   output state
        source;                         %   Structure array with source settings:
                                        %    - function (voltage/current)
                                        %    - voltage:
                                        %       - mode
                                        %       - level
                                        %       - range
                                        %    - current:
                                        %       - mode
                                        %       - level
                                        %       - range
        sense;                          %   Structure array with sense settings:
                                        %   - function (voltage/current)
                                        %   - concurrent (allowed or not)
                                        %   - voltage:
                                        %       - protection (compliance)
                                        %       - range
                                        %   - current:
                                        %       - protection (compliance)
                                        %       - range

        % Instrument Fields
        voltage;                        %   measured voltage
        current;                        %   measured current
        
        % Ramping parameters
        ramper;
        rampInfo;
        
    end
    
    methods
        function obj = Keithley2401(varargin)
            %Keithley2401 class constructor class
            obj.interface = "gpib";
            obj = obj.init(varargin{:});
            obj.rename("Keithley2401");
            
            obj.fields = {'voltage', 'current'};
            fieldsUnits = {'V', 'A'};
            obj.parameters = {'source_function', 'source_voltage_mode', ...
                            'source_voltage_level', 'source_voltage_range', ...
                            'source_current_mode', 'source_current_level', ...
                            'source_current_range', 'sense_function', ...
                            'sense_voltage_protection', 'sense_voltage_range', ...
                            'sense_current_protection', 'sense_current_range'};
            parametersUnits = {'', '', 'V', 'V', '', 'A', 'A', '', 'V', 'V', 'A', 'A'};
            units = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(units{:});
        end

        sweep(obj, v, dv, dt)
        sweep_to(obj, v)
        ramp(obj, V1, rate, period)
        apply(obj, I1, rate, period)

        % Getters (Parameters)
        function o = get.on(obj), o = obj.get('on'); end
        function v = get.voltage(obj), v = obj.get('voltage'); end
        function c = get.current(obj), c = obj.get('current'); end
        function s = get.source(obj)
            %FIXME remove dots from fields names.
            s = struct();
            s.function = obj.get('source.function');
            s.voltage.mode = obj.get('source.voltage.mode');
            s.voltage.level = obj.get('source.voltage.level');
            s.voltage.range = obj.get('source.voltage.range');
            s.current.mode = obj.get('source.current.mode');
            s.current.level = obj.get('source.current.level');
            s.current.range = obj.get('source.current.range');
        end
        function s = get.sense(obj)
            s = struct();
            s.function = obj.get('sense.function');
            s.concurrent = obj.get('sense.function.concurrent');
            s.voltage.protection = obj.get('sense.voltage.protection');
            s.voltage.range = obj.get('sense.voltage.range');
            s.current.protection = obj.get('sense.current.protection');
            s.current.range = obj.get('sense.current.range');
        end

        % Setters (Parameters)
        function set.on(obj, o), obj.set('on', o); end
        function set.source(obj, s)
            obj.set('source_function', s.function);
            switch lower(s.function)
                case {'voltage', 'volt', 'v'}
                    obj.set('source_voltage_mode', s.voltage.mode);
                    obj.set('source_voltage_level', s.voltage.level);
                    obj.set('source_voltage_range', s.voltage.range);
                case {'current', 'curr', 'c'}
                    obj.set('source_current_mode', s.current.mode);
                    obj.set('source_current_level', s.current.level);
                    obj.set('source_current_range', s.current.range);
            end
        end
        function set.sense(obj, s)
            if (s.voltage.range > s.voltage.protection) && (s.voltage.range ~= obj.sense.voltage.range)
                s.voltage.range = s.voltage.protection;
                util.msg("Warning: voltage.range is changed to voltage.protection.");
            end

            if ~ismember(s.function, "res")
                obj.set('sense_voltage_protection', s.voltage.protection);
                obj.set('sense_current_protection', s.current.protection);
            end
            if ismember(s.function, "volt")
                obj.set('sense_voltage_range', s.voltage.range);
            end
            
            
            if obj.sense.concurrent ~= s.concurrent
                obj.set('sense_function_concurrent', s.concurrent);
            end
            obj.set('sense_function', s.function);
            
            %FIXME: Error 823 poops up "Invalid with source read-back on"
            %if ismember(s.function, "curr")
            %    obj.set('sense_current_range', s.current.range);
            %end
        end

        % Display parameters
        function disp(obj)
            fprintf("Keithley 2401 Source Meter\n");
            fprintf("  GPIB Address: %d\n", obj.address);

            fprintf("  Output: %d\n", obj.on);
            fprintf("  Source:\n");
            fprintf("    Function: %s\n", obj.source.function);
            fprintf("    Voltage:\n");
            fprintf("      Mode: %s\n", obj.source.voltage.mode);
            fprintf("      Level: %f V\n", obj.source.voltage.level);
            fprintf("      Range: %f V\n", obj.source.voltage.range);
            fprintf("    Current:\n");
            fprintf("      Mode: %s\n", obj.source.current.mode);
            fprintf("      Level: %f A\n", obj.source.current.level);
            fprintf("      Range: %f A\n", obj.source.current.range);
            fprintf("  Sense:\n");
            fprintf("    Function: %s\n", obj.sense.function);
            fprintf("    Concurrent: %d\n", obj.sense.concurrent);
            fprintf("    Voltage:\n");
            fprintf("      Protection: %f V\n", obj.sense.voltage.protection);
            fprintf("      Range: %f V\n", obj.sense.voltage.range);
            fprintf("    Current:\n");
            fprintf("      Protection: %f A\n", obj.sense.current.protection);
            fprintf("      Range: %f A\n", obj.sense.current.range);

            fprintf("  Voltage: %f V\n", obj.voltage);
            fprintf("  Current: %f A\n", obj.current);
        end

        % Remp (voltage ramp)
        function rampStep(obj, ~)
            try
                i = obj.ramper.TasksExecuted;
                obj.set('source_voltage_level', obj.rampInfo.V_array(i));
                %obj.get('volt');
            catch ME
                disp(ME)
            end
        end
        
        function rampStop(obj, ~)
        end

        % Apply (current ramp)
        function applyStart(obj, ~)
            obj.source.function = 'current';
            obj.source.current.mode = 'fixed';
            obj.on = 1;
        end
        
        function applyStep(obj, ~)
            try
                i = obj.ramper.TasksExecuted;
                obj.set('source_current_level', obj.rampInfo.I_array(i));
            catch ME
                disp(ME)
            end
        end
        
        function applyStop(obj, ~)
            if obj.rampInfo.I_final == 0
                obj.on = 0;
            end
        end
        
    end
end

