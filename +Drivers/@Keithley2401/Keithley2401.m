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
            %obj.get('I');
        end
        
        function source(obj, v), obj.set('v', v); end
        
        %function sweep_step(obj, event)
        %    obj.source()
        %end
        %
        %function sweep_timer(obj, v, dv, dt)
        %    if nargin < 4, dt = .2; end
        %    if nargin < 3, dv = .005*dt; end
        %    if dv/dt > .005
        %        warning("Rate is too high.");
        %        return
        %    end
        %    v0 = obj.get('source');
        %    obj.range = linspace(v0, v, fix(abs(v-v0)/dv)+1);
        %    n_steps = numel(v_range);
        %
        %    obj.sweeper = timer('Tag', 'Keithley2401');
        %    obj.sweeper.Period = dt;
        %    obj.sweeper.TasksToExecute = n_steps;
        %    obj.sweeper.ExecutionMode = 'fixedRate';
        %    obj.sweeper.StartDelay = 0;
        %    obj.sweeper.TimerFcn = @(~, event)obj.sweep_step(event);
        %
        %    for i = 1:n_steps
        %        obj.set('v', v_range(i));
        %        pause(dt);
        %    end
        %end
    end
end

