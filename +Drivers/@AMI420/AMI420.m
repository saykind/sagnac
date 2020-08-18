classdef (Sealed = true) AMI420 < handle
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
        remote = false;             %   Whether instrument in local/remote mode
        
        fields;
    end

    methods
        function obj = AMI420(gpib, handle, varargin)
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
                error("AMI420 requires valid visa handle or GPIB address.");
            end
            
            obj.gpib = gpib;
            obj.handle = handle;
            obj.idn = sprintf("%s_%02d", obj.name, obj.gpib);
            
            % Set to REMOTE (if not set already)
            fprintf(handle, 'system:remote');
            obj.remote = true;
            
            % Test read
            obj.fields = {'X', 'Y', 'AUX1', 'AUX2'};
            %obj.read(obj.fields{:});
            
            if nargin > 2
                obj = obj.set(varargin{2:end});
            end
        end
        
        obj = set(obj, varargin);
        varargout = read(obj, varargin);
        
    end
end

