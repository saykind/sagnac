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
        sweeper;                        %   timer handle
        range;                          %   voltage range
        % Instrument Parameters 
        % (can be set and read)
        
        % Instrument Fields 
        % (cannot be set, can be read)
        on;                              %
        voltage;                         %   voltage on channel 1
        current;                         %   voltage on channel 2
        
        % Ramp timer
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
            obj.parameters = {};
            parametersUnits = {};
            units = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(units{:});
            
            %obj.update();
        end
        function output(obj)
            obj.write('output %d', 0); 
        end
        
        function sweep(obj, v, dv, dt)
            %if nargin < 4, dt = .2; end
            %if nargin < 3, dv = .005*dt; end
            if dv/dt > .1
                warning("Rate is too high.");
                return
            end
            v0 = obj.get('source');
            v_range = linspace(v0, v, fix(abs(v-v0)/dv)+1);
            for i = 1:numel(v_range)
                obj.set('v', v_range(i));
                pause(dt);
            end
        end
        
        function sweep_to(obj, v)
            dt = 0.2;
            dv = .01*dt;
            obj.sweep(v, dv, dt);
        end
        
        function source(obj, v), obj.set('v', v); end
        
        function ramp(obj, V1, rate, period)
        %Ramp voltage to specified value 'V1' (Volts)
        %at specified 'rate' (Volts/sec),
        %changing voltage every 'period'.
        %Default 'rate' is 0.1 Volts/sec.
        %Deafult 'period' is 0.1 sec.
            if nargin < 2, return; end
            if nargin < 3, rate = 0.1; end
            if nargin < 4, period = .25; end
            
            util.clearTimers(0, 'Keithley2401');
            
            obj.rampInfo = {};
            V0 = obj.get('v');
            obj.rampInfo.V_initial = V0;
            obj.rampInfo.V_final = V1;
            obj.rampInfo.rate = rate;
            num = fix(abs(V1-V0)/rate)/period;
            if num < 1, num=1; end
            obj.rampInfo.V_num = num;
            obj.rampInfo.V_array = linspace(V0, V1, num);
            
            obj.ramper = timer('Tag', 'Keithley2401');
            obj.rampInfo.name = obj.ramper.Name;
            obj.ramper.Period = period;
            obj.ramper.TasksToExecute = num;
            obj.ramper.ExecutionMode = 'fixedRate';
            obj.ramper.StartDelay = period;
            %obj.ramper.StartFcn = @(~, event)obj.rampStart(event);
            obj.ramper.TimerFcn = @(~, event)obj.rampStep(event);
            obj.ramper.StopFcn = @(~, event)obj.rampStop(event);
            %obj.ramper.ErrorFcn = @(~, event)obj.rampStop(event);
            
            obj.ramper.start();
        end
        
        function rampStep(obj, event)
            try
                i = obj.ramper.TasksExecuted;
                obj.set('v', obj.rampInfo.V_array(i));
            catch ME
                disp(ME)
            end
        end
        
        function rampStop(obj, event)
        end
    end
end

