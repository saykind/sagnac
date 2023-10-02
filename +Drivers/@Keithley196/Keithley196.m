classdef (Sealed = true) Keithley196 < Drivers.Device
    %Driver for Keithley 196 
    %   Release date: October 2023
    %   This class was created in Kapitulnik research group.
    %   
    %
    %   Matlab 2018b or higher is required.
    %   The following packages are used:
    %   - Instrument Control Toolbox
    %
    %
    %   Usage example:
    %   voltmeter = Drivers.Keithley196(7);
    %   v2 = voltmeter.get('v');
    
    properties       
        % Instrument Fields 
        % (cannot be set, can be read)
        v;                         %   voltage on channel 1
        
    end
    
    methods
        function obj = Keithley196(varargin)
            %LSCI331 class constructor class
            obj.interface = "gpib";
            obj = obj.init(varargin{:});
            obj.rename("Keithley196");
            
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

