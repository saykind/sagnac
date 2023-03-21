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
    addParameter(p, 'waveform', '', @(s)mustBeMember(s,{'', 'sin', 'square'}));
    addParameter(p, 'on', NaN, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    if ~isnan(parameters.frequency)
        obj.frequency = parameters.frequency;
        obj.write(sprintf("frequency %f", obj.frequency));
    end
    if ~isnan(parameters.amplitude)
        obj.amplitude = parameters.amplitude;
        obj.write("voltage:unit vpp");
        obj.write(sprintf("voltage %f", obj.amplitude));
    end
    if ~isnan(parameters.offset)
        obj.offset = parameters.offset;
        obj.write(sprintf("voltage:offset %f", obj.offset));
    end
    if ~isnan(parameters.waveform)
        disp("Setting waveform is not suppported yet.")
    end
    if ~isnan(parameters.on)
        obj.output()
    end
end