classdef (Sealed = true) ILX3724 < handle
    %Driver for Stanford Reasearch 844 Lock-in amplifier
    %   Release August 15, 2021 (v0.1)
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
    %   laser = Drivers.SR844();
    %   laser.set('current', 100);
    %   curr = lockin.get('current');
    
    properties
        name = 'ILX3724';
        gpib;                       %   GPIB address
        idn;                        %   Unique name
        handle;                     %   VISA-GPIB handle
        remote = false;             %   Whether instrument in remote mode
        
        mode;                       %   Output mode 
                                    %   1 = current, 
                                    %   2 = power, 
                                    %   3 = high-BW current.
        
        fields;                     %   Fields to read
        output;                     %   Whether the laser in ON/OFF (1/0)
        current;                    %   Output current
    end
    
    methods
        function obj = ILX3724(gpib, handle, varargin)
            %ILX3724 construct class
            %   If more than two arguments are present, 
            %   the rest arguments are passed to set method
            if ~nargin
                return;
            end
            
            if nargin == 1
                handle = Drivers.find_instrument(gpib);
            else
                if ~isa(handle, 'visa')
                    error("Instrument constructor accepts visa handles only.");
                end
                % Open instrument if it is closed
                if strcmp(handle.status, 'closed')
                    fopen(handle);
                end
            end
            
            obj.gpib = gpib;
            obj.handle = handle;
            obj.idn = sprintf("%s_%02d", obj.name, obj.gpib);
            
            if nargin > 2
                obj = obj.set(varargin{2:end});
            end
        end
        
        out = send(obj, msg);
        out = query(obj, msg);
        obj = set(obj, varargin);
        varargout = read(obj, varargin);
        
    end
end

