classdef HF2LI < Drivers.Device
    %Driver for Zurich Instruments HF2LI lock-in amplifiers.
    %
    %   Usage example:
    %   lockin = Drivers.HF2LI('dev18120');
    %   lockin.set('time constant', 1);
    %   [X, Y] = lockin.get('x', 'y');
    
    properties
        % Instrument Information (iternal)
        num_inputs = 2;             % Number of signal inputs
        num_outputs = 2;            % Number of signal outputs
        num_oscillators = 2;        % Number of oscillators
        num_demodulators = 6;       % Number of demodulators
        props;                      % Properties of the device

        % Instrument Parameters (global)
        %FIXME: remove later
        %Input Parameters
        input_range;                % Input ranges of all signal inputs
        input_ac;                   % Input couplings of all signal inputs
        input_impedance_50;         % Input impedances of all signal inputs
        %Output Parameters
        on;                         % Output status of all signal outputs
        output_range;               % Output ranges of all signal outputs
        amplitude;                  % Output amplitudes of all signal outputs
        output_mixer;               % Output mixer channels of all signal outputs
        %Oscillator Parameters
        frequency;                  % Frequencies of all oscillators
        %Demodulator Parameters
        phase;                      % Phases shift of all demodulators
        time_constant;              % Time constants of all demodulators
        
        % Instrument Parameters (specific)
        input;                      %   Structure array with input settings
                                    %    - range
                                    %    - ac (coupling: AC/DC)
                                    %    - impedance_50ohm (50/1e6)
        output;                     %   Structure array with output settings
                                    %    - on
                                    %    - range (V)
                                    %    - amplitude (V, peak-to-peak)
        oscillator;                 %   Structure array with oscillator settings
                                    %    - frequency
        demodulator;                %   Structure array with demodulator settings
                                    %    - enable
                                    %    - oscillator
                                    %    - harmonic
                                    %    - phase shift
                                    %    - order
                                    %    - time constant
                                    %    - sampling_rate (Sa/s)
                                    %    - trigger
        % Instrument Fields
        x;                          %   Re (in-phase) part of all demodulators
        y;                          %   Im (quadrature) part of all demodulators
        
    end
    
    methods
        function obj = HF2LI(device_id)
            obj.verbose = Inf; %FIXME set to 0 later
            if obj.verbose
                disp('[Drivers.HF2LI] Constructing the object...');
            end
            if nargin < 1, device_id = ''; end
            if isnan(device_id), device_id = ''; end
            obj.init(device_id);
            obj.fields = {'x', 'y'};
            obj.parameters = {'frequency', 'phase', 'time_constant'};
        end

        % Getters (parameters)
        %function f = get.frequency(obj), f = obj.get('f'); end
        %function phase = get.phase(obj), phase = obj.get('ph'); end
        % Getters( fields)
        function x = get.x(obj), x = obj.get('x'); end
        function y = get.y(obj), y = obj.get('y'); end

        % Setters
        %function set.frequency(obj, value), obj.set('f', value); end
        %function set.phase(obj, value), obj.set('ph', value); end

    end
end
