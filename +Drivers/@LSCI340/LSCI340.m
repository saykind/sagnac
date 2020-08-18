classdef (Sealed = true) LSCI340 < handle
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
        tempA;                      %   Temperature A (K)
        tempB;                      %   Temperature B (K)
    end
    
    methods
        function obj = LSCI340(gpib, handle, varargin)
            %Agilent33220A construct class
            %   If more than one argument ispresent, 
            %   the rest arguments are passed to set method
            if ~nargin
                return
            end
            
            if nargin == 1
                handle = Drivers.find_instrument(gpib);
            end
            
            if ~isa(handle, 'visa')
                error("LakeShore 340 constructor accepts visa handles only.");
            end
            
            obj.gpib = gpib;
            obj.handle = handle;
            obj.idn = sprintf("%s_%02d", obj.name, obj.gpib);
            
            % Set to REMOTE (if not set already)
            %fprintf(handle, 'locl 1');
            
            % Test read
            obj.fields = {'temp'};
            obj.read(obj.fields{:});
            
            if nargin > 2
                obj = obj.set(varargin{2:end});
            end
        end
        
        obj = set(obj, varargin);
        varargout = read(obj, varargin);
        
    end
end

