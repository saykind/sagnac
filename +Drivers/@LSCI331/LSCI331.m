classdef (Sealed = true) LSCI331 < Drivers.Device
    %Driver for Lakeshore 331 temperature controller
    %   Release February 2023
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
    %   temp = Drivers.LSCI331();
    %   [tempA, tempB] = temp.get('tempA', 'tempB');
    
    properties
        tempA;                      %   Temperature A (K)
        tempB;                      %   Temperature B (K)
        setTemp;                    %   Set temperature
        heater;
    end
    
    methods
        function obj = LSCI331(varargin)
            %LSCI331 class constructor class
            obj.interface = "visa";
            obj = obj.init(varargin{:});
            obj.rename("LSCI331");
            obj.remote = true;
            obj.fields = {'A', 'B'};
            obj.parameters = {'setTemp', 'heater'};
            obj.update();
        end
    end
end

