function set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   source.set('voltage', 1);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'voltage', NaN, @isnumeric);
    addParameter(p, 'current', NaN, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    if ~isnan(parameters.voltage)
        v = parameters.voltage;
        obj.write(sprintf(":source:voltage %d", v));
        obj.voltage = v;
    end
    if ~isnan(parameters.current)
        c = parameters.voltage;
        obj.write(sprintf(":source:channel %d", c));
        obj.voltage = c;
    end
end