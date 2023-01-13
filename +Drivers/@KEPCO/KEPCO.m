classdef (Sealed = true) KEPCO < handle
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
        name = 'KEPCO'
        gpib;                       %   GPIB address
        idn;                        %   Unique name
        handle;                     %   VISA-GPIB handle
        remote = false;             %   Whether instrument in local/remote mode
        
        voltageLimit;               %   
        currentLimit;               %   
        
        fields;                     %   Fields to read
        I;
        V;
    end
    
    methods
        function obj = KEPCO(gpib, handle, varargin)
            %Agilent33220A construct class
            %   If more than one argument ispresent, 
            %   the rest arguments are passed to set method
            if ~nargin
                return
            end
            
            if nargin == 1
                handle = Drivers.find_instrument(gpib);
            else
                if ~isa(handle, 'visa')
                    error("KEPCO constructor accepts visa handles only.");
                end
            end
            
            obj.gpib = gpib;
            obj.handle = handle;
            obj.idn = sprintf("%s_%02d", obj.name, obj.gpib);
            
            
            % Test read
            obj.fields = {'I', 'V'};
            obj.read(obj.fields{:});
            
            if nargin > 2
                obj = obj.set(varargin{2:end});
            end
        end
        
        obj = set(obj, varargin);
        varargout = read(obj, varargin);
        
    end
end

