classdef (Sealed = true) A33220A < handle
    %Driver for Agilent 33220A Wavefunction Generator
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
    %   wavegenerator = Drivers.Agilent33220A();
    %   wavegenerator.set('fequency', 5e6);
    %   wavegenerator.set('amplitude', 1);
    %   freq = wavegenerator.read('fequency');
    %   
    %   wavegenerator.sweep(startfreq, stepfreq, stopfreq);
    
    properties
        name = 'A33220A';
        gpib;                       %   GPIB address
        handle;                     %   VISA-GPIB handle
        idn;                        %   Unique name
        remote = false;             %   Whether instrument in local/remote mode
        
        fields;                     %   Fields to read
        functionform;               %   Waveform (sine, square, etc.)
        frequency;                  %   Waveform frequency (Hz)
        amplitude;                  %   Waveform peak-to-peak amplitude (V)
        offset;                     %   Voltage offset
    end
    
    methods
        function obj = A33220A(gpib, handle, varargin)
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
                error("Agilent33220A constructor accepts visa handles only.");
            end
            
            obj.gpib = gpib;
            obj.handle = handle;
            obj.idn = sprintf("%s_%02d", obj.name, obj.gpib);
            
            % Set to REMOTE (if not set already)
            fprintf(handle, 'system:remote');
            obj.remote = true;
            
            % Test read
            obj.fields = {'frequency', 'amplitude'};
            obj.read(obj.fields{:});
            
            if nargin > 2
                obj = obj.set(varargin{2:end});
            end
        end
        
        obj = set(obj, varargin);
        varargout = read(obj, varargin);
        
        obj = local(obj);
    end
end

