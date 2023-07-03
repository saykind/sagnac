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
    %   lockin = Drivers.SR844();
    %   lockin.set('time constant', 1);
    %   [X, Y] = lockin.read('X', 'Y');
    
    properties
        name = 'LSCI340';
        gpib;                       %   GPIB address
        idn;                        %   Unique name
        handle;                     %   VISA-GPIB handle
        
        fields;                     %   Fields to read
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
    end
end

