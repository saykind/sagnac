classdef HF2LI < Drivers.Device
    %Driver for Zurich Instruments HF2LI lock-in amplifiers.
    %
    %   Usage example:
    %   lockin = Drivers.HF2LI('dev18120');
    %   lockin.get('demodulator_frequency')
    %   lockin.set('demodulator_frequency', 5e6);
    %   lockin.demodulator.frequency(2) = 4.8e6;
    %   lockin.demodulator.frequency
    %   [X, Y] = lockin.get('x', 'y');
    
    properties
        % Instrument Information (iternal)
        props;                      % Properties of the device
        num = struct('inputs', 2, 'outputs', 2, 'oscillators', 2, 'demodulators', 6);

        % Instrument Parameters (temporary)
        %Input Parameters
        % input_range;                % Input ranges of all signal inputs
        % input_ac;                   % Input couplings of all signal inputs
        % input_impedance_50;         % Input impedances of all signal inputs
        %Output Parameters
        % output_on;                  % Output status of all signal outputs
        % output_mixer;               % Output mixer channels of all signal outputs
        % output_range;               % Output ranges of all signal outputs
        % output_amplitude;           % Output amplitudes of all signal outputs
        %Oscillator Parameters
        % oscillator_frequency;       % Frequencies of all oscillators
        %Demodulator Parameters
        % demodulator_enable;         % Enable status of all demodulators
        % demodulator_oscillator;     % Oscillator channels of all demodulators
        % demodulator_harmonic;       % Harmonic of all demodulators
        % demodulator_phase;          % Phase shift of all demodulators
        % demodulator_order;          % Order of all demodulators
        % demodulator_time_constant;  % Time constants of all demodulators
        % demodulator_sampling_rate;  % Sampling rates of all demodulators
        % demodulator_input;          % Input channel of all demodulators
        
        % Instrument Parameters (structures)
        input;                      %   Structure array with input settings
                                    %    - range
                                    %    - ac (coupling: AC/DC)
                                    %    - impedance_50ohm (50/1e6)
        output;                     %   Structure array with output settings
                                    %    - on
                                    %    - mixer (channel)
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
                                    %    - input
        % Instrument Fields
        x;                          %   Re (in-phase) part of all demodulators
        y;                          %   Im (quadrature) part of all demodulators

        % x1;                         %   Re (in-phase) part of demodulator 1
        % y1;                         %   Im (quadrature) part of demodulator 1
        % x2;                         %   Re (in-phase) part of demodulator 2
        % y2;                         %   Im (quadrature) part of demodulator 2
        % x3;                         %   Re (in-phase) part of demodulator 3
        % y3;                         %   Im (quadrature) part of demodulator 3
        % x4;                         %   Re (in-phase) part of demodulator 4
        % y4;                         %   Im (quadrature) part of demodulator 4
        % x5;                         %   Re (in-phase) part of demodulator 5
        % y5;                         %   Im (quadrature) part of demodulator 5
        % x6;                         %   Re (in-phase) part of demodulator 6
        % y6;                         %   Im (quadrature) part of demodulator 6
        
    end
    
    methods
        function obj = HF2LI(device_id)
            obj.verbose = Inf; %FIXME set to 0 later
            if obj.verbose
                disp('[Drivers.HF2LI] Constructing the object...');
            end
            if nargin < 1, device_id = ''; end
            if isnan(device_id), device_id = ''; end
            if isnumeric(device_id), device_id = ['dev' num2str(device_id)]; end
            obj.init(device_id);
            obj.configure();
            obj.fields = {'x', 'y'};
            obj.parameters = {'input', 'output', 'oscillator', 'demodulator'};
        end

        % Getters (parameters)
        function input = get.input(obj)
            range = obj.get('input_range');
            ac = obj.get('input_ac');
            impedance_50ohm = obj.get('input_impedance_50');
            input = struct('range', range, 'ac', ac, 'impedance_50ohm', impedance_50ohm);
        end
        function output = get.output(obj)
            on = obj.get('output_on');
            range = obj.get('output_range');
            amplitude = obj.get('output_amplitude');
            mixer = obj.get('output_mixer');
            output = struct('on', on, 'range', range, 'amplitude', amplitude, 'mixer', mixer);
        end
        function oscillator = get.oscillator(obj)
            frequency = obj.get('oscillator_frequency');
            oscillator = struct('frequency', frequency);
        end
        function demodulator = get.demodulator(obj)
            enable = obj.get('demodulator_enable');
            oscselect = obj.get('demodulator_oscillator');
            harmonic = obj.get('demodulator_harmonic');
            phase = obj.get('demodulator_phase');
            order = obj.get('demodulator_order');
            time_constant = obj.get('demodulator_time_constant');
            sampling_rate = obj.get('demodulator_sampling_rate');
            adcselect = obj.get('demodulator_input');
            demodulator = struct('enable', enable, 'oscillator', oscselect, 'harmonic', harmonic, ...
                                 'phase', phase, 'order', order, 'time_constant', time_constant, ...
                                 'sampling_rate', sampling_rate, 'input', adcselect);
        end
        % Getters( fields)
        function x = get.x(obj), x = obj.get('x'); end
        function y = get.y(obj), y = obj.get('y'); end

        % function x1 = get.x1(obj), x1 = obj.get('x1'); end
        % function y1 = get.y1(obj), y1 = obj.get('y1'); end
        % function x2 = get.x2(obj), x2 = obj.get('x2'); end
        % function y2 = get.y2(obj), y2 = obj.get('y2'); end
        % function x3 = get.x3(obj), x3 = obj.get('x3'); end
        % function y3 = get.y3(obj), y3 = obj.get('y3'); end
        % function x4 = get.x4(obj), x4 = obj.get('x4'); end
        % function y4 = get.y4(obj), y4 = obj.get('y4'); end
        % function x5 = get.x5(obj), x5 = obj.get('x5'); end
        % function y5 = get.y5(obj), y5 = obj.get('y5'); end
        % function x6 = get.x6(obj), x6 = obj.get('x6'); end
        % function y6 = get.y6(obj), y6 = obj.get('y6'); end

        % Setters
        function set.input(obj, input)
            obj.set('input_range', input.range);
            obj.set('input_ac', input.ac);
            obj.set('input_impedance_50', input.impedance_50ohm);
        end

        function set.output(obj, output)
            obj.set('output_on', output.on);
            obj.set('output_mixer', output.mixer);
            obj.set('output_range', output.range);
            obj.set('output_amplitude', output.amplitude);
        end

        function set.oscillator(obj, oscillator)
            obj.set('oscillator_frequency', oscillator.frequency);
        end

        function set.demodulator(obj, demodulator)
            obj.set('demodulator_enable', demodulator.enable);
            obj.set('demodulator_oscillator', demodulator.oscillator);
            obj.set('demodulator_harmonic', demodulator.harmonic);
            obj.set('demodulator_phase', demodulator.phase);
            obj.set('demodulator_order', demodulator.order);
            obj.set('demodulator_time_constant', demodulator.time_constant);
            obj.set('demodulator_sampling_rate', demodulator.sampling_rate);
            %demodulator.input cannot be modified
        end

    end
end
