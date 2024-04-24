classdef (Sealed = true) AH2500A < Drivers.Device
    %Driver for ANDEEN-HAGERLING 2500A Capacitance bridge
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
    %   magnetpowersupply = Drivers.AH2500A(28);
    %   magnetpowersupply.set('	', .1);
    %   C = magnetpowersupply.get('C');
    
    properties
        % Instrument Parameters 
        % (can be set and read)
        status;
        % Instrument fields
        C;
        L;
        V;
    end
    
    methods
        function obj = AH2500A(varargin)
        %AH2500A constructor
            obj.interface = "gpib";
            obj = obj.init(varargin{:});
            obj.rename("AM2500A");
            obj.fields = {'C', 'L', 'V'};
            obj.parameters = {'status'};
            obj.update();
        end
    end
end

