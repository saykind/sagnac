function obj = set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   obj.set('mode', 1);
    %   obj.set('current', 100);
    %   obj.set('output', 1);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'las', NaN, @isnumeric);
    addParameter(p, 'on', NaN, @isnumeric);
    addParameter(p, 'output', NaN, @isnumeric);
    
    addParameter(p, 'mode', NaN, @isnumeric);
    
    addParameter(p, 'I', NaN, @isnumeric);
    addParameter(p, 'current', NaN, @isnumeric);
    
    addParameter(p, 'tec', NaN, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    out = NaN;
    if ~isnan(parameters.las), out = parameters.las; end
    if ~isnan(parameters.on), out = parameters.on; end
    if ~isnan(parameters.output), out = parameters.output; end
    if ~isnan(out)
        if ismember(out, [0, 1])
            obj.write(sprintf("LAS:OUT %d", out));
            obj.las = out;
        else
            fprintf("[Drivers.ILX3724.set] Incorrect value.\n");
        end
    end
    
    if ~isnan(parameters.mode)
        mode = parameters.mode;
        if ~ismember(mode, [1, 2, 3])
            fprintf("[Drivers.ILX3724.set] Incorrect value.\n");
        else
            switch mode
                case 1
                    obj.write("LAS:MODE:ILBW");
                case 2
                    obj.write("LAS:MODE:MDP");
                case 3
                    obj.write("LAS:MODE:IHBW");
            end
            obj.mode = mode;
        end
    end
    
    current = NaN;
    if ~isnan(parameters.I), current = parameters.I; end
    if ~isnan(parameters.current), current = parameters.current; end
    if ~isnan(current)
        if (current < 0) || (current > 500)
            fprintf("[Drivers.ILX3724.set] Incorrect value.\n");
        else
            obj.write(sprintf("LAS:LDI %d", current));
            obj.current = current;
        end
    end
    
    if ~isnan(parameters.tec)
        if ismember(parameters.tec, [0, 1])
            obj.write(sprintf("TEC:OUT %d", parameters.tec));
            obj.tec = out;
        else
            fprintf("[Drivers.ILX3724.set] Incorrect value.\n");
        end
    end
    
end