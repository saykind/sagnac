function configure(obj)
    %Configure the device ready for Sagnac measurement.

    arguments
        obj Drivers.HF2LI;
    end

    % Input
    obj.set('input_range',          [.03 .3]);
    obj.set('input_ac',             [  1  1]);
    obj.set('input_impedance_50',   [  1  1]);

    % Output
    obj.set('output_on',            [    1   0]);
    obj.set('output_mixer',         [    1   0]);
    obj.set('output_range',         [   10   1]);
    obj.set('output_amplitude',     [ 1.148  0]);
    
    % Oscillator
    obj.set('oscillator_frequency', [4.834e6 4.834e6]);

    % Demodulator
    obj.set('demodulator_enable',       [1 1 1 1 1 1]);
    obj.set('demodulator_oscillator',   [1 1 2 1 1 2]);
    obj.set('demodulator_harmonic',     [1 2 1 2 1 2]);
    obj.set('demodulator_phase',        [-5 0 0 0 0 0]);
    obj.set('demodulator_order',        [4 4 4 4 4 4]);
    obj.set('demodulator_time_constant',[1 1 1 1 1 1]);
    obj.set('demodulator_sampling_rate',[5 5 5 5 5 5]);
    
    % Synchronize the device.
    ziDAQ('sync');

end