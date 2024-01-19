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
        X;                          %   Re part of the signal
        Y;                          %   Im part of the signal
        R;                          %   Signal Magnitude
        Q;                          %   Signal Phase
        AUX1;
        AUX2;
        AUXV1;
        AUXV2;
        % Ramp timer
        ramper;
        rampInfo;
    end
    
    methods
        function obj = SR830(varargin)
        %SR830 Constructor.
            obj = obj.init(varargin{:});
            obj.rename("SR830");
            obj.remote = true;
            
            obj.fields = {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'};
            fieldsUnits = {'V', 'V', 'V', 'deg', 'V', 'V'};
            obj.parameters = {'frequency', 'phase', 'amplitude', 'timeConstant'};
            parametersUnits = {'Hz',    'deg',      'V',        's'};
            tempUnits = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(tempUnits{:});
            
            obj.update();
        end
        
        function ramp(obj, V1, rate, period)
        %Ramp AUXV1 voltage to specified value
        %at specified rate (V/s).
        %Default rate is 0.01 V/s
            if nargin < 2, return; end
            if nargin < 3, rate = 0.01; end
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
            
            
            util.clearTimers(0, 'SR830');
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

