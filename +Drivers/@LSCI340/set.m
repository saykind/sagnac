function obj = set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   obj.set('fequency', 5e6);
    %   obj.set('amplitude', 1);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'timeConstant', NaN, @isnumeric);
    addParameter(p, 'function', '', @(s)mustBeMember(s,{'', 'sin', 'square'}));
    addParameter(p, 'heater', NaN, @isnumeric);
    addParameter(p, 'I', NaN, @isnumeric);
    addParameter(p, 'output', '', @ischar);
    addParameter(p, 'heaterRange', NaN, @isnumeric);
    addParameter(p, 'range', NaN, @isnumeric);
    addParameter(p, 'S', NaN, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    if ~isnan(parameters.timeConstant)
        tc = round(log(parameters.timeConstant)/log(10)*2+8);
        if tc < 1e-4 || tc > 30e3
            error('Time Constant has to be between 1e-4 and 3e4 seconds.');
        end
        obj.timeConstant = tc;
        fprintf(obj.handle, "oflt %f", tc);
    end
    
    if ~isnan(parameters.heater)
        fprintf(obj.handle, "mout 1, %.1f", parameters.heater);
    end
    
    if ~isnan(parameters.I)
        power = 100*parameters.I; 
        % Current in percents of 1 A.
        if power > 100
            power = 100;
        end
        fprintf(obj.handle, "mout 1, %.2f", power);
    end
    
    if ~isempty(parameters.output)
        if strcmp(parameters.output, 'on')
            fprintf(obj.handle, "cmode 1, 3");
            fprintf(obj.handle, "range 5");
        end
        if strcmp(parameters.output, 'off')
            fprintf(obj.handle, "cmode 1, 1");
            fprintf(obj.handle, "range 0");
        end
    end
    
    % Heater range
    hr = NaN;
    if ~isnan(parameters.heaterRange), hr = parameters.heaterRange; end
    if ~isnan(parameters.range), hr = parameters.range; end
    if ~isnan(hr)
        obj.write(sprintf("range %d", parameters.range));
    end
    
    if ~isempty(parameters.S)
        obj.write(sprintf("setp 1, %d", parameters.S));
    end
    
end