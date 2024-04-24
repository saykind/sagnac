function varargout = get(obj, varargin)
    %Parameters and fields reading method
    %
    %   Usage example:
    %   freq = obj.get('frequency');
    %   [freq, phase] = obj.get('f', 'ph');

    for i = 1:(nargin-1)
        switch varargin{i}
            %Parameters:
            % Input parameters:
            %   - input_range
            %   - input_ac
            %   - input_impedance
            %   - oscillator_frequency
            %   - phase
            %   - time constant
            %   - range
            %   - amplitude
            case {'input_range', 'range'}
                range = zeros(1, obj.num_inputs);
                for j = 1:obj.num_inputs
                    range(j) = ziDAQ('getDouble', ['/' obj.id '/sigins/' num2str(j-1) '/range']);
                end
                varargout{i} = range;
            case {'input_ac', 'ac', 'coupling'}
                ac = zeros(1, obj.num_inputs);
                for j = 1:obj.num_inputs
                    ac(j) = ziDAQ('getInt', ['/' obj.id '/sigins/' num2str(j-1) '/ac']);
                end
                varargout{i} = ac;
            case {'input_impedance_50', 'input_impedance', 'impedance'}
                impedance = zeros(1, obj.num_inputs);
                for j = 1:obj.num_inputs
                    impedance(j) = ziDAQ('getInt', ['/' obj.id '/sigins/' num2str(j-1) '/imp50']);
                end
                varargout{i} = impedance;
            case {'oscillator_frequency', 'frequency', 'freq', 'f'}
                f = zeros(1, obj.num_oscillators);
                for j = 1:obj.num_oscillators
                    f(j) = ziDAQ('getDouble', ['/' obj.id '/oscs/' num2str(j-1) '/freq']);
                end
                if obj.verbose && ~all(f == f(1))
                    warning('Not all oscillator frequencies are not the same'); 
                end
                varargout{i} = f;
            case {'phase', 'ph'}
                phase = zeros(1, obj.num_demodulators);
                for j = 1:obj.num_demodulators
                    phase(j) = ziDAQ('getDouble', ['/' obj.id '/demods/' num2str(j-1) '/phaseshift']);
                end
                varargout{i} = phase;
            case {'time_constant', 'tc'}
                tc = zeros(1, obj.num_demodulators);
                for j = 1:obj.num_demodulators
                    tc(j) = ziDAQ('getDouble', ['/' obj.id '/demods/' num2str(j-1) '/timeconstant']);
                end
                varargout{i} = tc;
            case {'amplitude', 'a'}
                amplitude = zeros(1, obj.num_outputs);
                for j = 1:obj.num_outputs
                    amplitude(j) = ziDAQ('getDouble', ['/' obj.id '/sigouts/' num2str(j-1) '/amplitudes/0']);
                end
                varargout{i} = amplitude;
            %Fields:
            %   - sample
            %   - x
            %   - y
            case {'sample'}
                for j = 1:obj.num_demodulators
                    sample(j) = ziDAQ('getSample', ['/' obj.id '/demods/' num2str(j-1) '/sample']);
                end
                varargout{i} = sample;
            case {'x'}
                x = zeros(1, obj.num_demodulators);
                for j = 1:obj.num_demodulators
                    % check is demodulator is enabled
                    if ~ziDAQ('getInt', ['/' obj.id '/demods/' num2str(j-1) '/enable'])
                        x(j) = NaN;
                        continue
                    end
                    sample = ziDAQ('getSample', ['/' obj.id '/demods/' num2str(j-1) '/sample']);
                    x(j) = sample.x;
                end
                varargout{i} = x;
            case {'y'}
                y = zeros(1, obj.num_demodulators);
                for j = 1:obj.num_demodulators
                    % check is demodulator is enabled
                    if ~ziDAQ('getInt', ['/' obj.id '/demods/' num2str(j-1) '/enable'])
                        y(j) = NaN;
                        continue
                    end
                    sample = ziDAQ('getSample', ['/' obj.id '/demods/' num2str(j-1) '/sample']);
                    y(j) = sample.y;
                end
                varargout{i} = y;
            otherwise
                error('[Drivers.HF2LI.get] Unknown argument.');
        end
    end
end