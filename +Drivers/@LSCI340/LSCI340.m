classdef (Sealed = true) LSCI340 < Drivers.Device
    %Driver for Lake Shore 340 temperature controller
    %   This class defines the driver for the Lake Shore 340 temperature
    %   controller. It allows to control the temperature of the device and
    %   read the temperature values.
    %
    %   Usage example:
    %   gpib = 16;
    %   tempcont = LSCI340(gpib);
    %   tempcont.A
    %   tempcont.ramp_rate = 10;
    %   tempcont.S = 290;
    
    
    properties
        % Internal properties
        loop = 1;                   %   Either 1 or 2

        % Parameters
        control_mode;               %   Control mode
                                    %       1 = Manual PID
                                    %       2 = Zone
                                    %       3 = Open Loop
                                    %       4 = AutoTune PID
                                    %       5 = AutoTune PI
                                    %       6 = AutoTune P
        control_enable;             %   Control enable/disable, 0 = off, 1 = on
        heater_range;               %   Heater range (0, 1, 2, 3, 4, 5)
        manual_output;              %   Manual heater output (%)
                                    %   0 to 100% with 0.01% resolution
        pid;                        %   [Proportional, Integral, Derivative]
                                    %       0.1 <= P <= 1000 with 0.1 resolution
                                    %         1 <= I <= 1000 with 0.1 resolution
                                    %         1 <= D <= 1000 s with 1 s resolution
        ramp_on;                    %   Ramping On/Off
        ramp_rate;                  %   Ramping rate (K/min)
                                    %   0.1 K/min to 100 K/min with 0.1 K/min resolution
        ramp_status;                %   Is ramping now?
        setpoint;                   %   Setpoint temperature (K)

        % Fields
        A;                          %   Temperature A (K)           %FIXME: rename to a in future versions
        B;                          %   Temperature B (K)           %FIXME: rename to b in future versions
        heater;                     %   Heater current (% of max current)
    end
    
    methods
        function obj = LSCI340(varargin)
        %LSCI340 construct class
            obj = obj.init(varargin{:});
            obj.rename("LSCI340");
            
            obj.fields = {'A', 'B', 'heater'};
            fieldUnits = {'K', 'K', '%'};
            obj.parameters = {'control_mode', 'control_enable', 'heater_range', 'manual_output', ...
                                'pid', 'ramp_on', 'ramping', 'ramp_rate', 'setpoint'};
            parameterUnits = {'',             '',               '',             '%', ...
                                '',    '',        '',        'K/min', 'K'};
            units = [[obj.fields, obj.parameters]; [fieldUnits, parameterUnits]];
            obj.units = struct(units{:});
        end

        ramp(obj, setp, rate)               %   Ramp temperature to setpoint 
        room(obj)                           %   Warmup to room temperature
        
        % Getters (Parameters)
        function cm = get.control_mode(obj), cm = obj.get('control_mode'); end
        function ce = get.control_enable(obj), ce = obj.get('control_enable'); end
        function hr = get.heater_range(obj), hr = obj.get('heater_range'); end
        function mout = get.manual_output(obj), mout = obj.get('manual_output'); end
        function pid = get.pid(obj), pid = obj.get('pid'); end
        function ro = get.ramp_on(obj), ro = obj.get('ramp_on'); end
        function rr = get.ramp_rate(obj), rr = obj.get('ramp_rate'); end
        function rs = get.ramp_status(obj), rs = obj.get('ramp_status'); end
        function ts = get.setpoint(obj), ts = obj.get('S'); end
        

        % Getters (Fields)
        function ta = get.A(obj), ta = obj.get('A'); end
        function tb = get.B(obj), tb = obj.get('B'); end
        function htr = get.heater(obj), htr = obj.get('heater'); end

        % Setters (Parameters)
        function set.control_mode(obj, cm), obj.set('control_mode', cm); end
        function set.control_enable(obj, ce), obj.set('control_enable', ce); end
        function set.heater_range(obj, hr), obj.set('heater_range', hr); end
        function set.manual_output(obj, mout), obj.set('manual_output', mout); end
        function set.pid(obj, pid), obj.set('PID', pid); end
        function set.ramp_on(obj, ramp_on), obj.set('ramp_on', ramp_on); end
        function set.ramp_rate(obj, rr), obj.set('ramp_rate', rr); end
        function set.setpoint(obj, s), obj.set('setpoint', s); end
    end
end

