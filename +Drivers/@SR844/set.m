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
    addParameter(p, 'tc', NaN, @isnumeric);
    addParameter(p, 'timeConstant', NaN, @isnumeric);
    addParameter(p, 'sens', NaN, @isnumeric);
    addParameter(p, 'sensitivity', NaN, @isnumeric);
    addParameter(p, 'harm', NaN, @isnumeric);
    addParameter(p, 'harmonic', NaN, @(x)ismember(x,[0,1]));
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    f = NaN;
    if ~isnan(parameters.f), f = parameters.f; end
    if ~isnan(parameters.freq), f = parameters.freq; end
    if ~isnan(parameters.frequency), f = parameters.frequency; end
    if ~isnan(f)
        obj.write(sprintf("freq %f", f));
        obj.write("keyp 49");
    end
    ph = NaN;
    if ~isnan(parameters.ph), ph = parameters.ph; end
    if ~isnan(parameters.phase), ph = parameters.phase; end
    if ~isnan(ph)
        obj.write(sprintf("phas %f", ph));
        obj.write("keyp 43");
    end
    tc = NaN;
    if ~isnan(parameters.tc), tc = parameters.tc; end
    if ~isnan(parameters.timeConstant), tc = parameters.timeConstant; end
    if ~isnan(tc)
        tc = round(log(tc)/log(10)*2+8);
        if tc < 1e-4 || tc > 30e3
            error('Time Constant has to be between 1e-4 and 3e4 seconds.');
        end
        obj.timeConstant = tc;
        obj.write(sprintf("oflt %f", tc));
    end
    sens = NaN;
    if ~isnan(parameters.sens), sens = parameters.sens; end
    if ~isnan(parameters.sensitivity), sens = parameters.sensitivity; end
    if ~isnan(sens)
        sens = floor(log(sens)/log(10)*2+15);
        if sens > 14, sens = 14; end
        if sens < 0,  sens = 0;  end
        obj.sensitivity = sens;
        obj.write(sprintf("sens %i", sens));
    end
    harm = NaN;
    if ~isnan(parameters.harm), harm = parameters.harm; end
    if ~isnan(parameters.harmonic), harm = parameters.harmonic; end
    if ~isnan(harm)
        obj.write(sprintf("harm %i", harm));
    end
end