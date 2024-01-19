function set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   lockin.set('amplitude', .2);
    %   lockin.set('f', 5e6, 'tc', 1);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'f', NaN, @isnumeric);
    addParameter(p, 'freq', NaN, @isnumeric);
    addParameter(p, 'frequency', NaN, @isnumeric);
    addParameter(p, 'ph', NaN, @isnumeric);
    addParameter(p, 'phase', NaN, @isnumeric);
    addParameter(p, 'a', NaN, @isnumeric);
    addParameter(p, 'ampl', NaN, @isnumeric);
    addParameter(p, 'amplitude', NaN, @isnumeric);
    addParameter(p, 'tc', NaN, @isnumeric);
    addParameter(p, 'timeConstant', NaN, @isnumeric);
    addParameter(p, 'AUXV1', NaN, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    f = NaN;
    if ~isnan(parameters.f), f = parameters.f; end
    if ~isnan(parameters.freq), f = parameters.freq; end
    if ~isnan(parameters.frequency), f = parameters.frequency; end
    if ~isnan(f)
        obj.frequency = f;
        obj.write(sprintf("freq %f", f));
    end
    ph = NaN;
    if ~isnan(parameters.ph), ph = parameters.ph; end
    if ~isnan(parameters.phase), ph = parameters.phase; end
    if ~isnan(ph)
        obj.phase = ph;
        obj.write(sprintf("phas %f", ph));
    end
    a = NaN;
    if ~isnan(parameters.a), a = parameters.a; end
    if ~isnan(parameters.ampl), a = parameters.ampl; end
    if ~isnan(parameters.amplitude), a = parameters.amplitude; end
    if ~isnan(a)
        obj.amplitude = a;
        obj.write(sprintf("slvl %f", a))
    end
    tc = NaN;
    if ~isnan(parameters.tc), tc = parameters.tc; end
    if ~isnan(parameters.timeConstant), tc = parameters.timeConstant; end
    if ~isnan(tc)
        tc = round(log(tc)/log(10)*2+10);
        if tc < 1e-4 || tc > 30e3
            error('Time Constant has to be between 1e-4 and 3e4 seconds.');
        end
        obj.timeConstant = tc;
        obj.write(sprintf("oflt %f", tc));
    end
    if ~isnan(parameters.AUXV1)
        obj.write(sprintf("AUXV 1, %f", parameters.AUXV1));
    end
end