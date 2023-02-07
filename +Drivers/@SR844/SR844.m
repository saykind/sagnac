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
            obj.remote = true;
            obj.fields = {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'};
            obj.parameters = {'freq', 'phase', 'tc'};
        end
    end
end

