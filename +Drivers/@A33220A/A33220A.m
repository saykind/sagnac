classdef A33220A < Drivers.Device
    %Driver for Agilent 33220A waveform generator.
    %   Release date: February, 2023.
    %   This class was created in Kapitulnik research group.
    %   Written by David Saykin (saykind@itp.ac.ru).
    %
    %   Matlab 2018b or higher is required.
    %   The following packages are used:
    %   - Instrument Control Toolbox
    %
    %
    %   Usage example:
    %   waveform = Drivers.A33220A(19);
    %   waveform.set('freq', 5e6);
    %   [freq, ampl] = waveform.read('f', 'a');
    
    properties
        % Instrument Parameters 
        % (can be set and read)
        frequency;                  %   Internal frequency (Hz)
        amplitude;                  %   Output amplitude (Vpp)
        offset;                     %   Voltage DC offset (V)
        waveform;                   %   Either 'sin' or 'square'
        on;                         %   Whether it is on or off
    end
    
    methods
        function obj = A33220A(varargin)
            obj = obj.init(varargin{:});
            obj.rename("A33220A");
            obj.fields = {};
            obj.parameters = {'freq', 'ampl', ...
                'offset', 'waveform', 'on'};
            obj.update();
        end
        function out = output(obj)
        %Turn output on if it's off and vice versa.
            out = ~obj.get("on");
            if obj.on
                obj.write("output 0");
            else
                obj.write("output 1");
            end
        end
    end
end

