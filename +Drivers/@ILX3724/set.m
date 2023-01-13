function obj = set(obj, varargin)
    %Parameter set method
    %
    %   obj.set('mode', 1);
    %   obj.set('current', 100);
    %   obj.set('output', 1);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'output', NaN, @isnumeric);
    addParameter(p, 'mode', NaN, @isnumeric);
    addParameter(p, 'current', NaN, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    if ~isnan(parameters.output)
        output = parameters.output;
        fprintf(obj.handle, "LAS:OUT %d", output);
    end
    
    if ~isnan(parameters.current)
        current = parameters.current;
        fprintf(obj.handle, "LAS:LDI %d", current);
    end
    
end