classdef (Sealed = true) ILX3724 < Drivers.Device
    %Driver for ILX LightWave LDC-3724C laser diode controller
    %   Release April, 2023 (v1)
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
    %   laser = Drivers.ILX3724();
    %   laser.set('current', 100);
    %   curr = lockin.get('current');
    
    properties
        las;                        %   Whether laser is ON(1) or OFF(0)
        lasmode;                    %   Laser mode:
                                    %       1 = current (low-BW), 
                                    %       2 = power, 
                                    %       3 = high-BW current.
        
        current;                    %   Output current
        voltage;                    %   Diode voltage
        
        tec;                        %   Whether TEC is ON(1) or OFF(0)
        tecmode;                    %   TEC mode:
                                    %       1 = Temperature, 
                                    %       2 = Resistance, 
                                    %       3 = Current (I_TE).
        temperature;                %   Thermistor-based temp
        resistance;                 %   Thermistor resistance
    end
    
    methods
        function obj = ILX3724(varargin)
        %ILX3724 constructor
            obj = obj.init(varargin{:});
            obj.rename("ILX3724");
            obj.remote = true;
            obj.fields = {};
            obj.parameters = {'las', 'lasmode', 'current', 'voltage', ...
                'tec', 'tecmode', 'temperature', 'resistance'};
            obj.update();
        end
        function output(obj, current)
        %Turn output on if it's off and vice versa.
            if nargin == 2
                obj.set('current', current);
                obj.set('las', 1);
            else
                out = double(~obj.get('on'));
                obj.set('las', out);
            end
        end
    end
end

