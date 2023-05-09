classdef (Sealed = true) AMI420 < handle %FIXME
    %Driver for American Magnetics, 420
    %   Release August 1, 2020 (v0.1)
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
    %   magnet = Drivers.AMI420();
    %   magnet.set('rate', 10);
    %   magnet.run();
    %   magnet.read();
    
    properties
        name = 'AMI420';
        gpib;                       %   GPIB address
        idn;                        %   Unique name
        handle;                     %   VISA-GPIB handle
        fields;                     %   Fields to record
        remote = false;             %   Whether instrument in local/remote mode
        
        state;                      %   Magnet state (ramping/holding/paused)
        %timeUnits;                  
        coilConstant;               %   Coil constant (T/A)  
        fieldUnits;                 %   Field units (T or kG)
        programmedField;            %   Programmed field (in field units)
        programmedCurrent;          %   Programmed current (in A)
        
        rampRateField;              %   Ramp rate (in fieldUnits/timeUnits)
        rampRateCurrent;            %   Ramp rate (in A/timeUnits)
        
        field;                      %   Measured field (requries coil const)
        current;                    %   Measured current (in A)
        voltage;                    %   Magnet voltage (in V)
        voltageSupply;              %   Power supply voltage (in V)
        
        pswitchState;               %   Whether pswitch is on
        pswitchVoltage;             %   Persistent switch heater voltage
        pswitchTime;                %   Persistent switch time
    end

    methods
        function obj = AMI420(varargin)
            %Agilent33220A construct class
            %   If more than one argument ispresent, 
            %   the rest arguments are passed to set method
            obj.fields = {'field'};
            
            if ~nargin
                return
            end
            
            if nargin == 1
                obj.load(varargin{1});
                return;
            end
            
            obj.load(varargin{1:2});
            
            if nargin > 2
                obj = obj.set(varargin{3:end});
            end
        end
        
        % Methods
        obj = load(obj, gpib, handle);
        obj = set(obj, varargin);
        varargout = read(obj, varargin);
        obj = update(obj);
        
        obj = local(obj);
        obj = ramp(obj);
        obj = pswitch(obj);
    end
end

