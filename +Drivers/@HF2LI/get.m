function varargout = get(obj, varargin)
    %Parameters and fields reading method
    %
    %   Available parameters:
    %   - input_range
    %   - input_ac
    %   - input_impedance_50
    %   - output_on
    %   - output_range
    %   - output_amplitude
    %   - output_mixer
    %   - oscillator_frequency
    %   - demodulator_enable
    %   - demodulator_oscillator
    %   - demodulator_harmonic
    %   - demodulator_phase
    %   - demodulator_order
    %   - demodulator_time_constant
    %   - demodulator_sampling_rate
    %   - demodulator_input
    %
    %   Usage example:
    %   amplitude = obj.get('output_amplitude');
    %   [freq, phase] = obj.get('f', 'ph');

    for i = 1:(nargin-1)
        switch varargin{i}
            %%Parameters
            % Input parameters:
            %   - input_range
            %   - input_ac
            %   - input_impedance
            case {'input_range', 'range'}
                range = zeros(1, obj.num.inputs);
                for j = 1:obj.num.inputs
                    range(j) = ziDAQ('getDouble', ['/' obj.id '/sigins/' num2str(j-1) '/range']);
                end
                varargout{i} = range;
            case {'input_ac', 'ac', 'coupling'}
                ac = zeros(1, obj.num.inputs);
                for j = 1:obj.num.inputs
                    ac(j) = ziDAQ('getInt', ['/' obj.id '/sigins/' num2str(j-1) '/ac']);
                end
                varargout{i} = ac;
            case {'input_impedance_50', 'input_impedance', 'impedance'}
                impedance = zeros(1, obj.num.inputs);
                for j = 1:obj.num.inputs
                    impedance(j) = ziDAQ('getInt', ['/' obj.id '/sigins/' num2str(j-1) '/imp50']);
                end
                varargout{i} = impedance;
            
            % Output parameters:
            %   - output_on
            %   - output_range
            %   - output_amplitude
            %   - output_mixer
            %   - output_default_mixer
            case {'output_on', 'on'}
                on = zeros(1, obj.num.outputs);
                for j = 1:obj.num.outputs
                    on(j) = ziDAQ('getInt', ['/' obj.id '/sigouts/' num2str(j-1) '/on']);
                end
                varargout{i} = on;
            case {'output_range'}
                range = zeros(1, obj.num.outputs);
                for j = 1:obj.num.outputs
                    range(j) = ziDAQ('getDouble', ['/' obj.id '/sigouts/' num2str(j-1) '/range']);
                end
                varargout{i} = range;
            case {'output_amplitude'}
                amplitude = zeros(1, obj.num.outputs);
                for j = 1:obj.num.outputs
                    mixer_channel = ziGetDefaultSigoutMixerChannel(obj.props, j-1);
                    amplitude(j) = ziDAQ('getDouble', ['/' obj.id '/sigouts/' num2str(j-1) '/amplitudes/' mixer_channel]);
                end
                varargout{i} = amplitude;
            case {'output_mixer'}
                mixer = zeros(1, obj.num.outputs);
                for j = 1:obj.num.outputs
                    mixer_channel = ziGetDefaultSigoutMixerChannel(obj.props, j-1);
                    mixer(j) = ziDAQ('getInt', ['/' obj.id '/sigouts/' num2str(j-1) '/enables/' mixer_channel]);
                end
                varargout{i} = mixer;
            case {'output_default_mixer'}
                mixer = zeros(1, obj.num.outputs);
                for j = 1:obj.num.outputs
                    mixer(j) = ziGetDefaultSigoutMixerChannel(obj.props, j-1);
                end
                varargout{i} = mixer;

            % Oscillator parameters:
            %   - oscillator_frequency
            case {'oscillator_frequency'}
                f = zeros(1, obj.num.oscillators);
                for j = 1:obj.num.oscillators
                    f(j) = ziDAQ('getDouble', ['/' obj.id '/oscs/' num2str(j-1) '/freq']);
                end
                varargout{i} = f;

            % Demodulator parameters:
            %   - demodulator_enable
            %   - demodulator_oscillator
            %   - demodulator_harmonic
            %   - demodulator_phase
            %   - demodulator_order
            %   - demodulator_time_constant
            %   - demodulator_sampling_rate
            %   - demodulator_input
            case {'demodulator_enable'}
                enable = zeros(1, obj.num.demodulators);
                for j = 1:obj.num.demodulators
                    enable(j) = ziDAQ('getInt', ['/' obj.id '/demods/' num2str(j-1) '/enable']);
                end
                varargout{i} = enable;
            case {'demodulator_oscillator'}
                oscillator = zeros(1, obj.num.demodulators);
                for j = 1:obj.num.demodulators
                    oscillator(j) = 1 + ziDAQ('getInt', ['/' obj.id '/demods/' num2str(j-1) '/oscselect']);
                end
                varargout{i} = oscillator;
            case {'demodulator_harmonic'}
                harmonic = zeros(1, obj.num.demodulators);
                for j = 1:obj.num.demodulators
                    harmonic(j) = ziDAQ('getInt', ['/' obj.id '/demods/' num2str(j-1) '/harmonic']);
                end
                varargout{i} = harmonic;
            case {'demodulator_phase'}
                phase = zeros(1, obj.num.demodulators);
                for j = 1:obj.num.demodulators
                    phase(j) = ziDAQ('getDouble', ['/' obj.id '/demods/' num2str(j-1) '/phaseshift']);
                end
                varargout{i} = phase;
            case {'demodulator_order'}
                order = zeros(1, obj.num.demodulators);
                for j = 1:obj.num.demodulators
                    order(j) = ziDAQ('getInt', ['/' obj.id '/demods/' num2str(j-1) '/order']);
                end
                varargout{i} = order;
            case {'demodulator_time_constant'}
                time_constant = zeros(1, obj.num.demodulators);
                for j = 1:obj.num.demodulators
                    time_constant(j) = ziDAQ('getDouble', ['/' obj.id '/demods/' num2str(j-1) '/timeconstant']);
                end
                if obj.verbose && ~all(time_constant == time_constant(1))
                    warning('Not all demodulator time constants are the same'); 
                end
                varargout{i} = time_constant;
            case {'demodulator_sampling_rate'}
                sampling_rate = zeros(1, obj.num.demodulators);
                for j = 1:obj.num.demodulators
                    sampling_rate(j) = ziDAQ('getDouble', ['/' obj.id '/demods/' num2str(j-1) '/rate']);
                end
                if obj.verbose && ~all(sampling_rate == sampling_rate(1))
                    warning('Not all demodulator sampling rates are the same'); 
                end
                varargout{i} = sampling_rate;
            case {'demodulator_input'}
                input = zeros(1, obj.num.demodulators);
                for j = 1:obj.num.demodulators
                    input(j) = 1 + ziDAQ('getInt', ['/' obj.id '/demods/' num2str(j-1) '/adcselect']);
                end
                varargout{i} = input;


            %%Fields:
            %   - sample
            %   - x
            %   - y
            %   - x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6
            case {'sample'}
                for j = 1:obj.num.demodulators
                    sample(j) = ziDAQ('getSample', ['/' obj.id '/demods/' num2str(j-1) '/sample']);
                end
                varargout{i} = sample;
            case {'x'}
                x = zeros(1, obj.num.demodulators);
                for j = 1:obj.num.demodulators
                    % check if demodulator is enabled
                    if ~ziDAQ('getInt', ['/' obj.id '/demods/' num2str(j-1) '/enable'])
                        x(j) = NaN;
                        continue
                    end
                    sample = ziDAQ('getSample', ['/' obj.id '/demods/' num2str(j-1) '/sample']);
                    x(j) = sample.x;
                end
                varargout{i} = x;
            case {'y'}
                y = zeros(1, obj.num.demodulators);
                for j = 1:obj.num.demodulators
                    % check if demodulator is enabled
                    if ~ziDAQ('getInt', ['/' obj.id '/demods/' num2str(j-1) '/enable'])
                        y(j) = NaN;
                        continue
                    end
                    sample = ziDAQ('getSample', ['/' obj.id '/demods/' num2str(j-1) '/sample']);
                    y(j) = sample.y;
                end
                varargout{i} = y;
            case {'x1', 'y1', 'x2', 'y2', 'x3', 'y3', 'x4', 'y4', 'x5', 'y5', 'x6', 'y6'}
                j = str2double(varargin{i}(2));
                % check if demodulator is enabled
                if ~ziDAQ('getInt', ['/' obj.id '/demods/' num2str(j-1) '/enable'])
                    varargout{i} = NaN;
                    continue
                end
                sample = ziDAQ('getSample', ['/' obj.id '/demods/' num2str(j-1) '/sample']);
                varargout{i} = sample.(varargin{i}(1));
            otherwise
                error('[Drivers.HF2LI.get] Unknown argument.');
        end
    end
end