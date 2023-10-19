classdef (Sealed = true) KEPCO < Drivers.Device
    %Driver for KEPCO Lock-in amplifier
    %   Release November 6, 2022 (v0.1)
    %
    %   This class was created in Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru)
    %
    %   Matlab 2018b or higher is required.
    %   The following packages are used:
    %   - Instrument Control Toolbox
    %
    %
    %   Usage example:
    %   magnetpowersupply = Drivers.KEPCO();
    %   magnetpowersupply.set('current', .1);
    %   [I, V] = magnetpowersupply.read('I', 'V');
    
    properties
        % Instrument Parameters 
        % (can be set and read)
        voltageLimit;
        currentLimit;
        I;
        V;
        on;
        % Internal parameters
        coilConstant = 650; %G/A
        % Ramp timer
        ramper;
        rampInfo;
    end
    
    methods
        function obj = KEPCO(varargin)
        %KEPCO constructor
            obj = obj.init(varargin{:});
            obj.rename("KEPCO");
            obj.remote = true;
            obj.fields = {'I', 'V'};
            obj.parameters = {'voltageLimit', 'currentLimit'};
            obj.update();
        end
        
        function output(obj, current)
        %Turn output on if it's off and vice versa.
            if nargin == 2
                obj.set('I', current);
                obj.set('output', 1);
            else
                out = double(~obj.get('on'));
                obj.set('output', out);
            end
        end
        
        function ramp(obj, I1, rate, period)
        %Ramp current to specified value (Amps)
        %at specified rate (A/s).
        %Default rate is 0.010 A/s (2.5 G/s)
            if nargin < 2, return; end
            if nargin < 3, rate = 0.01; end
            if nargin < 4, period = .5; end
            
            obj.rampInfo = {};
            I0 = obj.get('I');
            obj.rampInfo.I_initial = I0;
            obj.rampInfo.I_final = I1;
            obj.rampInfo.rate = rate;
            num = fix(abs(I1-I0)/rate)/period;
            if num < 1, num=1; end
            obj.rampInfo.I_num = num;
            obj.rampInfo.I_array = linspace(I0, I1, num);
            
            util.clearTimers(0, 'KEPCO');
            obj.ramper = timer('Tag', 'KEPCO');
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
                obj.output(obj.rampInfo.I_array(i));
            catch ME
                disp(ME)
            end
        end
        
        function rampStop(obj, event)
            try
                if obj.rampInfo.I_array(end) == 0
                    obj.output();
                end
            catch ME
                disp(ME)
            end
        end
        
    end
end

