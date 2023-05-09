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
    
    properties (Access = private)
        loop = 1;                   %   Either 1 or 2
        % Instrument Parameters 
        % (can be set and read)
        rampRate;                   %   Setpoint ramping rate
        setTemp;                    %   Set temperature
        manualOutput;               %   Manual heater power (MHP) output
        heaterRange;                %   Sets max heater current:
                                    %       0 - Off
                                    %       1 - Low (.5 W, 10 mA)
                                    %       2 - Medium (5 W, 100 mA)
                                    %       3 - High (50 W, 1 A)
        pid;                        %   [Proportional, Integral, Derivative]
        
        % Instrument Fields 
        % (cannot be set, can be read)
        tempA;                      %   Temperature A (K)
        tempB;                      %   Temperature B (K)
        heater;                     %   Heater current in % of max current
        heaterState;                %   Heater state:
                                    %       0 -- No error
                                    %       1 -- Open load
                                    %       2 -- Short load
        rampState;                  %   Ramping (1) or not (0)
        
    end
    
    methods
        function obj = LSCI331(varargin)
            %LSCI331 class constructor class
            obj.interface = "visa";
            obj = obj.init(varargin{:});
            obj.rename("LSCI331");
            obj.remote = true;
            
            obj.fields = {'A', 'B', 'heater'};
            fieldsUnits = {'K', 'K', '%'};
            obj.parameters = {'setTemp'};
            parametersUnits = {'K'};
            units = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(units{:});
            
            obj.update();
        end
        function ramp(obj, setp, rate)
            if nargin < 2, return; end
            if nargin < 3, rate = obj.rampRate; end
            obj.rampRate =rate;
            obj.set('setp', setp);
        end
    end
end

