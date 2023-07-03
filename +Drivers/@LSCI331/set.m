function set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   tempcont.set('mode', 4);
    %   tempcont.set('heaterRange', 3);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'remote', NaN, @isnumeric);
    addParameter(p, 'mode', NaN, @isnumeric);
    addParameter(p, 'pid', NaN, @isnumeric);
    addParameter(p, 'manualOutput', NaN, @isnumeric);
    addParameter(p, 'pid', NaN, @isnumeric);
    addParameter(p, 'heaterRange', NaN, @isnumeric);
    addParameter(p, 'S', NaN, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    if ~isnan(parameters.remote)
        obj.remote = parameters.remote;
        obj.write(sprintf("MODE %d", obj.remote));
    end
    if ~isnan(parameters.mode)
        obj.mode = parameters.mode;
        obj.write(sprintf("CMODE %d, %d", obj.loop, obj.mode));
    end
    if ~isnan(parameters.pid)
        p = parameters.pid(1);
        i = parameters.pid(2);
        d = parameters.pid(3);
        if p < 0.1,  p = 0.1;  end
        if p > 1000, p = 1000; end
        if i < 0.1,  i = 0.1;  end
        if i > 1000, i = 1000; end
        if d < 0,    d = 0;    end
        if d > 200,  d = 200;  end
        obj.pid = parameters.pid;
        obj.write(sprintf("PID %d, %.4f, %.4f, %.4f", obj.loop, p, i, d));
    end
    
    if ~isnan(parameters.manualOutput)
        obj.manualOutput = parameters.manualOutput;
        obj.write(sprintf("MOUT %d, %d", obj.loop, obj.manualOutput));
    end
    if ~isnan(parameters.heaterRange)
        obj.heaterRange = parameters.heaterRange;
        obj.write(sprintf("RANGE %d", obj.heaterRange));
    end
    if ~isnan(parameters.S)
        obj.S = parameters.S;
        obj.write(sprintf("SETP %d, %f", obj.loop, obj.S));
    end
end