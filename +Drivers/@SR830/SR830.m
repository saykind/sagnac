classdef SR830 < Drivers.Device
    %Driver for Stanford Reasearch 830 lock-in amplifiers.
    %   Release date: February, 2023.
    %   This class was created in Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru).
    %
    %   Matlab 2018b or higher is required.
    %   The following packages are used:
    %   - Instrument Control Toolbox
    %
    %
    %   Usage example:
    %   lockin = Drivers.SR830();
    %   lockin.set('time constant', 1);
    %   [X, Y] = lockin.read('X', 'Y');
    
    properties
        % Instrument Parameters 
        % (can be set and read)
        frequency;                  %   Internal frequency (Hz)
        phase;                      %   Phase offset (deg)
        amplitude;                  %   Output amplitude (V)
        timeConstant;               %   Time constant (sec)
        % Instrument Fields 
        % (cannot be set, can be read)
        X;                          %   Re part of the signal (V)
        Y;                          %   Im part of the signal (V)
        R;                          %   Signal Magnitude (V)
        Q;                          %   Signal Phase (deg)
        AUX1;                       %   Auxiliary input 1 (V)  
        AUX2;                       %   Auxiliary input 2 (V)
        AUXV1;                      %   Auxiliary output 1 (V)
        AUXV2;                      %   Auxiliary output 2 (V)
        % Ramp timer
        ramper;
        rampInfo;
    end
    
    methods
        function obj = SR830(varargin)
        %SR830 Constructor.
            obj = obj.init(varargin{:});
            obj.rename("SR830");
            
            obj.fields = {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'};
            fieldsUnits = {'V', 'V', 'V', 'deg', 'V', 'V'};
            obj.parameters = {'frequency', 'phase', 'amplitude', 'timeConstant'};
            parametersUnits = {'Hz',    'deg',      'V',        's'};
            tempUnits = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(tempUnits{:});
            
            obj.update();
        end

        % Getters
        function f = get.frequency(obj), f = obj.get('frequency'); end
        function ph = get.phase(obj), ph = obj.get('phase'); end
        function a = get.amplitude(obj), a = obj.get('amplitude'); end
        function AUX1 = get.AUX1(obj), AUX1 = obj.get('AUX1'); end
        function AUX2 = get.AUX2(obj), AUX2 = obj.get('AUX2'); end
        function AUXV1 = get.AUXV1(obj), AUXV1 = obj.get('AUXV1'); end
        function AUXV2 = get.AUXV2(obj), AUXV2 = obj.get('AUXV2'); end

        % Setters
        function set.frequency(obj, value), obj.set('frequency', value); end
        function set.phase(obj, value), obj.set('phase', value); end
        function set.amplitude(obj, value), obj.set('amplitude', value); end
        function set.AUXV1(obj, value), obj.set('AUXV1', value); end
        function set.AUXV2(obj, value), obj.set('AUXV2', value); end
        
        function ramp(obj, V1, rate, period)
        %Ramp AUXV1 voltage to specified value
        %at specified rate (V/s).
        %Default rate is 0.02 V/s
            if nargin < 2, return; end
            if nargin < 3, rate = 0.02; end
            if nargin < 4, period = .5; end
            
            obj.rampInfo = {};
            V0 = obj.get('AUXV1');
            obj.rampInfo.V_initial = V0;
            obj.rampInfo.V_final = V1;
            obj.rampInfo.rate = rate;
            num = fix(abs(V1-V0)/rate)/period;
            if num < 1, num=1; end
            obj.rampInfo.V_num = num;
            obj.rampInfo.V_array = linspace(V0, V1, num);
            
            
            util.timers.clearall(0, 'SR830');
            obj.ramper = timer('Tag', 'SR830');
            obj.rampInfo.name = obj.ramper.Name;
            obj.ramper.Period = period;
            obj.ramper.TasksToExecute = num;
            obj.ramper.ExecutionMode = 'fixedRate';
            obj.ramper.StartDelay = period;
            obj.ramper.TimerFcn = @(~, event)obj.rampStep(event);
            obj.ramper.StopFcn = @(~, event)obj.rampStop(event);
            
            obj.ramper.start();
        end
        
        function rampStep(obj, event)
            try
                i = obj.ramper.TasksExecuted;
                obj.set('AUXV1', obj.rampInfo.V_array(i));
            catch ME
                disp(ME)
            end
        end
        
        function rampStop(obj, event)
        end
    end
end

