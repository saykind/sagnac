classdef (Sealed = true) Newport1830 < Drivers.Device
    %Driver for Newport 1830-C Optical power meter
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
    %   power_meter = Drivers.Newport1830(13);
    %   power_meter.set('units', 'uW')
    %   power = power_meter.get('power');
    
    properties
        % Instrument Parameters 
        % (can be set and read)
        filter;                     %   Slow, Medium, or Fast/No averaging
        range;                      %   Sets range(sensitivity):
                                    %       0 - Auto
                                    %       1 - Lowest
                                    %       ...
                                    %       8 - Highest
        wavelength;                 %   Operations wavelength 
        
        % Instrument Fields 
        % (cannot be set, can be read)
        power;                      %   Power reading (W)
        
    end
    
    methods
        function obj = Newport1830(varargin)
            %LSCI331 class constructor class
            obj.interface = "gpib";
            obj = obj.init(varargin{:});
            obj.rename("Newport1830");
            
            obj.fields = {'power'};
            fieldsUnits = {'W'};
            obj.parameters = {'filter', 'range', 'wavelength'};
            parametersUnits = {'', '', 'nm' };
            units = [[obj.fields, obj.parameters]; ...
                [fieldsUnits, parametersUnits]];
            obj.units = struct(units{:});
            
            %obj.update();
        end
        function auto_range(obj), obj.set('range', 0); end
    end
end

