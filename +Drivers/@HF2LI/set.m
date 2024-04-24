function set(obj, options)
    %Parameter set method
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
    %
    %   Usage example:
    %   obj.set('frequency', 5e6);
    %   obj.set('f', [5e6, 4.836e6], 'tc', [1, 1, 1, .3, .3, .3]);

    arguments
        obj Drivers.HF2LI;
        % Input parameters
        options.input_range double = [];
        options.input_ac double = [];
        options.input_impedance_50 double = [];
        % Output parameters
        options.output_on double = [];
        options.output_range double = [];
        options.output_amplitude double = [];
        options.output_mixer double = [];
        % Oscillator parameters
        options.oscillator_frequency double = [];
        % Demodulator parameters
        options.demodulator_enable double = [];
        options.demodulator_oscillator double = [];
        options.demodulator_harmonic double = [];
        options.demodulator_phase double = [];
        options.demodulator_order double = [];
        options.demodulator_time_constant double = [];
        options.demodulator_sampling_rate double = [];
        options.demodulator_input double = [];
    end
   
    
    %% Set values
    % Input parameters
    if ~isempty(options.input_range)
        range = options.input_range;
        if numel(range) > obj.num.inputs
            error('[Drivers.HF2LI.set] The number of input ranges must be smaller then the number of inputs.');
        end
        for j = 1:numel(range)
            ziDAQ('setDouble', ['/' obj.id '/sigins/' num2str(j-1) '/range'], range(j));
        end
    end
    
    if ~isempty(options.input_ac)
        ac = options.input_ac;
        if numel(ac) > obj.num.inputs
            error('[Drivers.HF2LI.set] The number of input AC couplings must be smaller then the number of inputs.');
        end
        for j = 1:numel(ac)
            ziDAQ('setInt', ['/' obj.id '/sigins/' num2str(j-1) '/ac'], ac(j));
        end
    end

    if ~isempty(options.input_impedance_50)
        impedance = options.input_impedance_50;
        if numel(impedance) > obj.num.inputs
            error('[Drivers.HF2LI.set] The number of input impedances must be smaller then the number of inputs.');
        end
        for j = 1:numel(impedance)
            ziDAQ('setInt', ['/' obj.id '/sigins/' num2str(j-1) '/imp50'], impedance(j));
        end
    end

    % Output parameters
    if ~isempty(options.output_on)
        on = options.output_on;
        if numel(on) > obj.num.outputs
            error('[Drivers.HF2LI.set] The number of output on/off settings must be smaller then the number of outputs.');
        end
        for j = 1:numel(on)
            ziDAQ('setInt', ['/' obj.id '/sigouts/' num2str(j-1) '/on'], on(j));
        end
    end

    if ~isempty(options.output_mixer)
        mixer = options.output_mixer;
        if numel(mixer) > obj.num.outputs
            error('[Drivers.HF2LI.set] The number of output mixer settings must be smaller then the number of outputs.');
        end
        for j = 1:numel(mixer)
            mixer_channel = ziGetDefaultSigoutMixerChannel(obj.props, j-1);
            ziDAQ('setInt', ['/' obj.id '/sigouts/' num2str(j-1) '/enables/' mixer_channel], mixer(j));
        end
    end

    if ~isempty(options.output_range)
        range = options.output_range;
        if numel(range) > obj.num.outputs
            error('[Drivers.HF2LI.set] The number of output ranges must be smaller then the number of outputs.');
        end
        for j = 1:numel(range)
            ziDAQ('setDouble', ['/' obj.id '/sigouts/' num2str(j-1) '/range'], range(j));
        end
    end

    if ~isempty(options.output_amplitude)
        amplitude = options.output_amplitude;
        value = amplitude./obj.get('output_range');
        if numel(value) > obj.num.outputs
            error('[Drivers.HF2LI.set] The number of output amplitudes must be smaller then the number of outputs.');
        end
        for j = 1:numel(value)
            mixer_channel = ziGetDefaultSigoutMixerChannel(obj.props, j-1);
            ziDAQ('setDouble', ['/' obj.id '/sigouts/' num2str(j-1) '/amplitudes/' mixer_channel], value(j));
        end
    end

    % Oscillator parameters
    if ~isempty(options.oscillator_frequency)
        frequency = options.oscillator_frequency;
        if numel(frequency) > obj.num.oscillators
            error('[Drivers.HF2LI.set] The number of oscillator frequencies must be smaller then the number of oscillators.');
        end
        for j = 1:numel(frequency)
            ziDAQ('setDouble', ['/' obj.id '/oscs/' num2str(j-1) '/freq'], frequency(j));
        end
    end

    % Demodulator parameters
    if ~isempty(options.demodulator_enable)
        enable = options.demodulator_enable;
        if numel(enable) > obj.num.demodulators
            error('[Drivers.HF2LI.set] The number of demodulator enable settings must be smaller then the number of demodulators.');
        end
        for j = 1:numel(enable)
            ziDAQ('setInt', ['/' obj.id '/demods/' num2str(j-1) '/enable'], enable(j));
        end
    end

    if ~isempty(options.demodulator_oscillator)
        oscillator = options.demodulator_oscillator;
        if numel(oscillator) > obj.num.demodulators
            error('[Drivers.HF2LI.set] The number of demodulator oscillator settings must be smaller then the number of demodulators.');
        end
        for j = 1:numel(oscillator)
            ziDAQ('setInt', ['/' obj.id '/demods/' num2str(j-1) '/oscselect'], oscillator(j)-1);
        end
    end

    if ~isempty(options.demodulator_harmonic)
        harmonic = options.demodulator_harmonic;
        if numel(harmonic) > obj.num.demodulators
            error('[Drivers.HF2LI.set] The number of demodulator harmonic settings must be smaller then the number of demodulators.');
        end
        for j = 1:numel(harmonic)
            ziDAQ('setInt', ['/' obj.id '/demods/' num2str(j-1) '/harmonic'], harmonic(j));
        end
    end

    if ~isempty(options.demodulator_phase)
        phase = options.demodulator_phase;
        if numel(phase) > obj.num.demodulators
            error('[Drivers.HF2LI.set] The number of demodulator phase settings must be smaller then the number of demodulators.');
        end
        for j = 1:numel(phase)
            ziDAQ('setDouble', ['/' obj.id '/demods/' num2str(j-1) '/phaseshift'], phase(j));
        end
    end

    if ~isempty(options.demodulator_order)
        order = options.demodulator_order;
        if numel(order) > obj.num.demodulators
            error('[Drivers.HF2LI.set] The number of demodulator order settings must be smaller then the number of demodulators.');
        end
        for j = 1:numel(order)
            ziDAQ('setInt', ['/' obj.id '/demods/' num2str(j-1) '/order'], order(j));
        end
    end

    if ~isempty(options.demodulator_time_constant)
        time_constant = options.demodulator_time_constant;
        if numel(time_constant) > obj.num.demodulators
            error('[Drivers.HF2LI.set] The number of demodulator time constant settings must be smaller then the number of demodulators.');
        end
        for j = 1:numel(time_constant)
            ziDAQ('setDouble', ['/' obj.id '/demods/' num2str(j-1) '/timeconstant'], time_constant(j));
        end
    end

    if ~isempty(options.demodulator_sampling_rate)
        sampling_rate = options.demodulator_sampling_rate;
        if numel(sampling_rate) > obj.num.demodulators
            error('[Drivers.HF2LI.set] The number of demodulator sampling rate settings must be smaller then the number of demodulators.');
        end
        for j = 1:numel(sampling_rate)
            ziDAQ('setDouble', ['/' obj.id '/demods/' num2str(j-1) '/rate'], sampling_rate(j));
        end
    end

    % Syncronize all data paths.
    ziDAQ('sync');
end