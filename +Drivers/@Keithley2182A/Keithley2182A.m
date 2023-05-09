classdef (Sealed = true) Keithley2182A < Drivers.Device
    %Driver for Keithley 2182A Nanovoltmeter
    %   Release date: April 2023
    %   This class was created in Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru)
    %
    %   Matlab 2018b or higher is required.
    %   The following packages are used:
    %   - Instrument Control Toolbox
    %
    %
    %   Usage example:
    %   voltmeter = Drivers.Keithley2182A(17);
    %   voltmeter.set('ch', 2);
    %   v2 = voltmeter.get('v');
    
    properties
        % Instrument Parameters 
        % (can be set and read)
        channel;                    %   which one is selected (1 or 2)
        range;                      %   Sets range(sensitivity):
                                    %       0 - Auto
                                    %       # - voltage
        
        % Instrument Fields 
        % (cannot be set, can be read)
        v1;                         %   voltage on channel 1
        v2;                         %   voltage on channel 2
        
    end
    
    methods
        function obj = Keithley2182A(varargin)
            %LSCI331 class constructor class
            obj.interface = "gpib";
            obj = obj.init(varargin{:});
            obj.rename("Keithley2182A");
            
            obj.fields = {'v1', 'v2'};
            fieldsUnits = {'V', 'V'};
            obj.parameters = {'channel', 'range'};
            parametersUnits = {'', 'V'};
            units = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(units{:});
            
            obj.update();
        end
        function auto_range(obj), obj.set('range', 0); end
    end
end

