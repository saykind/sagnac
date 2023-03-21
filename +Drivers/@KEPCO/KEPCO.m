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
        % Instrument Fields 
        % (cannot be set, can be read)
        I;
        V;
    end
    
    methods
        function obj = KEPCO(varargin)
            %KEPCO class constructor class
            obj = obj.init(varargin{:});
            obj.rename("KEPCO");
            obj.remote = true;
            obj.fields = {'I', 'V'};
            obj.parameters = {'voltageLimit', 'currentLimit'};
            obj.update();
        end
    end
end

