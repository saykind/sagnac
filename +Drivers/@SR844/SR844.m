classdef (Sealed = true) SR844 < handle
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
        name = 'SR844';
        gpib;                       %   GPIB address
        idn;                        %   Unique name
        handle;                     %   VISA-GPIB handle
        remote = false;             %   Whether instrument in local/remote mode
        
        timeConstant;               %   Time constant (sec)
        
        fields;                     %   Fields to read
        X;
        Y;
        R;
        Q;
        AUX1;
        AUX2;
    end
    
    methods
        function obj = SR844(gpib, handle, varargin)
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
                    error("Stanford Research 844 constructor accepts visa handles only.");
                end
            end
            
            obj.gpib = gpib;
            obj.handle = handle;
            obj.idn = sprintf("%s_%02d", obj.name, obj.gpib);
            
            % Set to REMOTE (if not set already)
            fprintf(handle, 'locl 1');
            obj.remote = true;
            
            % Test read
            obj.fields = {'X', 'Y', 'AUX1', 'AUX2'};
            obj.read(obj.fields{:});
            
            if nargin > 2
                obj = obj.set(varargin{2:end});
            end
        end
        
        obj = set(obj, varargin);
        varargout = read(obj, varargin);
        
    end
end

