classdef (Sealed = true) LSCI331 < Drivers.Device
    %Driver for Lakeshore 331 temperature controller
    %   Release date: February 2023
    %   This class was created in Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru)
    %
    %   Matlab 2018b or higher is required.
    %   The following packages are used:
    %   - Instrument Control Toolbox
    %
    %
    %   Usage example:
    %   temp = Drivers.LSCI331();
    %   [tempA, tempB] = temp.get('tempA', 'tempB');
    
    properties (Access = public)
        % Instrument Parameters 
        % (can be set and read)
        loop = 1;                   %   Either 1 or 2 [Internal]
        mode;                       %   Loop mode:
                                    %       1 - Manual PID
                                    %       2 - Zone
                                    %       3 - Open loop
                                    %       4 - AutoTune PID
                                    %       5 - AutoTune PI
                                    %       6 - AutoTune P
        pid;                        %   [Proportional, Integral, Derivative]
                                    %       0.1 <= P <= 1000
                                    %       0.1 <= I <= 1000
                                    %       0   <= D <= 200
                                    
        rampOn;                     %   Ramping On/Off
        ramping;                    %   Is ramping now? 
        rampRate;                   %   Ramping rate [Internal]
        
        manualOutput;               %   Manual heater power (MHP) output
        heaterRange;                %   Sets max heater current:
                                    %       0 - Off
                                    %       1 - Low (.5 W, 10 mA)
                                    %       2 - Medium (5 W, 100 mA)
                                    %       3 - High (50 W, 1 A)
        heaterMaxCurrent;           %   HeaterRange in Amps [Internal]
        S;                          %   Set temperature
        
        % Instrument Fields 
        % (cannot be set, can be read)
        A;                          %   Temperature A (K)
        B;                          %   Temperature B (K)
        heater;                     %   Heater current in % of max current
        heaterCurrent;              %   Heater value in Amps [Internal]
        heaterState;                %   Heater state:
                                    %       0 -- No error
                                    %       1 -- Open load
                                    %       2 -- Short load
    end
    
    methods
        function obj = LSCI331(varargin)
        %LSCI331 class constructor class
            obj.interface = "visa";
            obj = obj.init(varargin{:});
            obj.rename("LSCI331");
            obj.remote = true;
            
            obj.fields = {'A', 'B', 'S', 'current'};
            fieldsUnits = {'K', 'K', 'K', 'A'};
            obj.parameters = {'loop', 'mode', 'pid', ...
                'rampOn', 'ramping', 'rampRate',...
                'manualOutput', 'heaterState', 'heaterMaxCurrent'};
            parametersUnits = {'', '', '', ...
                '', '', 'K/min', ...
                '%', '', 'A'};
            units = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(units{:});
            
            obj.update();
        end
        function ramp(obj, setp, rate)
            if nargin < 2
                rate = obj.get('rampRate');
                isRampOn = obj.get('rampOn');
                obj.write(sprintf("RAMP %d, %d, %.2f", ...
                    obj.loop, ~isRampOn, rate));
                return;
            end
            if nargin < 3, rate = obj.rampRate; end
            if rate < 0.1, rate = 0.1; end
            if rate > 100, rate = 100; end
            obj.rampRate = rate;
            
            if obj.get('heaterRange') == 0
                obj.set('heaterRange', 3);
            end
            
            obj.write(sprintf("RAMP %d, 1, %f", obj.loop, rate));
            obj.set('S', setp);
        end
    end
end

