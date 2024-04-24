function configure(obj)
    %Configure the device ready for this experiment.

    arguments
        obj Drivers.HF2LI;
    end

    %FIXME: default values
    demod_c = '0'; % Demod channel, 0-based indexing for paths on the device.
    demod_idx = str2double(demod_c) + 1; % 1-based indexing, to access the data.
    out_c = '0'; % signal output channel
    % Get the value of the instrument's default Signal Output mixer channel.
    out_mixer_c = num2str(ziGetDefaultSigoutMixerChannel(props, str2num(out_c)));
    in_c = '0'; % signal input channel
    osc_c = '0'; % oscillator
    time_constant = 0.001; % [s]
    demod_rate = 2e3;
    amplitude = 1; % [V]
    
    
    try
        ziDAQ('setInt', ['/' obj.id '/sigins/' in_c '/imp50'], 0);
        ziDAQ('setInt', ['/' obj.id '/sigins/' in_c '/ac'], 0);
        %ziDAQ('setDouble', ['/' obj.id '/sigins/' in_c '/range'], 2.0*obj.amplitude);
        ziDAQ('setInt', ['/' obj.id '/sigouts/' out_c '/on'], 1);
        ziDAQ('setDouble', ['/' obj.id '/sigouts/' out_c '/range'], 10);
        ziDAQ('setDouble', ['/' obj.id '/sigouts/' out_c '/amplitudes/*'], 0);
        ziDAQ('setDouble', ['/' obj.id '/sigouts/' out_c '/amplitudes/' out_mixer_c], amplitude);
        ziDAQ('setDouble', ['/' obj.id '/sigouts/' out_c '/enables/' out_mixer_c], 1);
        if strfind(props.devicetype, 'HF2')
            ziDAQ('setInt', ['/' obj.id '/sigins/' in_c '/diff'], 0);
            ziDAQ('setInt', ['/' obj.id '/sigouts/' out_c '/add'], 0);
        end
        ziDAQ('setDouble', ['/' obj.id '/demods/*/phaseshift'], 0);
        ziDAQ('setInt', ['/' obj.id '/demods/*/order'], 8);
        ziDAQ('setDouble', ['/' obj.id '/demods/' demod_c '/rate'], demod_rate);
        ziDAQ('setInt', ['/' obj.id '/demods/' demod_c '/harmonic'], 1);
        ziDAQ('setInt', ['/' obj.id '/demods/' demod_c '/enable'], 1);
        ziDAQ('setInt', ['/' obj.id '/demods/*/oscselect'], str2double(osc_c));
        ziDAQ('setInt', ['/' obj.id '/demods/*/adcselect'], str2double(in_c));
        ziDAQ('setDouble', ['/' obj.id '/demods/*/timeconstant'], time_constant);
        ziDAQ('setDouble', ['/' obj.id '/oscs/' osc_c '/freq'], 30e5); % [Hz]

        % Unsubscribe all streaming data.
        ziDAQ('unsubscribe', '*');

        ziDAQ('sync');

        % Subscribe to the demodulator sample.
        ziDAQ('subscribe', ['/' device '/demods/' demod_c '/sample']);

    catch ME
        disp(ME.message);
        return
    end
    

end