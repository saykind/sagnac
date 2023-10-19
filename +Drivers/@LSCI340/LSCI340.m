classdef (Sealed = true) LSCI340 < Drivers.Device% FIXME
    %Driver for Stanford Reasearch 844 Lock-in amplifier
    %   Release August 5, 2020 (v0.1)
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
    %   lockin = Drivers.LSCI340();
    %   lockin.set('time constant', 1);
    %   [X, Y] = lockin.read('X', 'Y');
    
    properties
        loop = 1;                   %   Either 1 or 2 [Internal]
        pid;                        %   [Proportional, Integral, Derivative]
                                    %       0.1 <= P <= 1000
                                    %       0.1 <= I <= 1000
                                    %       0   <= D <= 200
        rampOn;                     %   Ramping On/Off
        ramping;                    %   Is ramping now? 
        rampRate;                   %   Ramping rate [Internal]
        A;                          %   Temperature A (K)
        B;                          %   Temperature B (K)
    end
    
    methods
        function obj = LSCI340(varargin)
        %LSCI340 construct class
            obj = obj.init(varargin{:});
            obj.rename("LSCI340");
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
                obj.set('heaterRange', 4);
            end
            
            obj.write(sprintf("RAMP %d, 1, %f", obj.loop, rate));
            obj.set('S', setp);
        end
    end
end

