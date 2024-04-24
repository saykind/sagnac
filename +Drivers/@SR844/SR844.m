classdef SR844 < Drivers.Device
    %Driver for Stanford Reasearch 844 lock-in amplifiers.
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
    %   lockin = Drivers.SR844();
    %   lockin.set('time constant', 1);
    %   [X, Y] = lockin.read('X', 'Y');
    
    properties
        % Instrument Parameters 
        % (can be set and read)
        frequency;                  %   Internal frequency (Hz)
        phase;                      %   Phase offset (deg)
        timeConstant;               %   Time constant (sec)
        sensitivity;                %   Range (from 1e-8 to 1)
        harmonic;                   %   Harmonic 1f (0) or 2f (1)
        % Instrument Fields 
        % (cannot be set, can be read)
        X;                          %   Re part of the signal
        Y;                          %   Im part of the signal
        R;                          %   Signal Magnitude
        Q;                          %   Signal Phase
        AUX1;
        AUX2;
    end
    
    methods
        function obj = SR844(varargin)
            obj = obj.init(varargin{:});
            obj.rename("SR844");
            obj.fields = {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'};
            obj.parameters = {'freq', 'phase', 'tc', ...
                'sensitivity', 'harmonic'};
            obj.update();
        end

        % Getters (parameters)
        function f = get.frequency(obj), f = obj.get('f'); end
        function phase = get.phase(obj), phase = obj.get('ph'); end
        function harm = get.harmonic(obj), harm = obj.get('harm'); end
        % Getters( fields)
        function x = get.X(obj), x = obj.get('X'); end
        function y = get.Y(obj), y = obj.get('Y'); end
        function r = get.R(obj), r = obj.get('R'); end
        function q = get.Q(obj), q = obj.get('Q'); end
        function aux1 = get.AUX1(obj), aux1 = obj.get('AUX1'); end
        function aux2 = get.AUX2(obj), aux2 = obj.get('AUX2'); end

        % Setters
        function set.frequency(obj, value), obj.set('f', value); end
        function set.phase(obj, value), obj.set('ph', value); end
        function set.harmonic(obj, value), obj.set('harm', value); end

    end
end

