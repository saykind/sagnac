classdef (Sealed = true) Keithley2000 < Drivers.Device
    %Driver for Keithley 2000 
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
    %   voltmeter = Drivers.Keithley2000(7);
    %   v2 = voltmeter.get('v');
    
    properties       
        % Instrument Fields 
        % (cannot be set, can be read)
        v;                         %   voltage on channel 1
        
    end
    
    methods
        function obj = Keithley2000(varargin)
            %LSCI331 class constructor class
            obj.interface = "gpib";
            obj = obj.init(varargin{:});
            obj.rename("Keithley2000");
            
            obj.fields = {'v'};
            fieldsUnits = {'V'};
            obj.parameters = {};
            parametersUnits = {};
            units = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(units{:});
            
            obj.update();
        end
        function auto_range(obj), obj.write(":volt:range:auto 1"); end
    end
end

