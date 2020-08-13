function obj = set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   wavegenerator.set('fequency', 5e6);
    %   wavegenerator.set('amplitude', 1);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'frequency', NaN, @isnumeric);
    addParameter(p, 'amplitude', NaN, @isnumeric);
    addParameter(p, 'offset', NaN, @isnumeric);
    addParameter(p, 'function', '', @(s)mustBeMember(s,{'', 'sin', 'square'}));
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    if ~isnan(parameters.frequency)
        obj.frequency = parameters.frequency;
        fprintf(obj.handle, "frequency %f", obj.frequency);
    end
    if ~isnan(parameters.amplitude)
        obj.amplitude = parameters.amplitude;
        fprintf(obj.handle, "voltage:unit vpp");
        fprintf(obj.handle, "voltage %f", obj.amplitude);
    end
    if ~isnan(parameters.offset)
        obj.offset = parameters.offset;
        fprintf(obj.handle, "voltage:offset %f", obj.offset);
    end
    
end