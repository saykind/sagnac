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
    end
end

