function obj = set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   obj.set('fequency', 5e6);
    %   obj.set('amplitude', 1);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'timeConstant', NaN, @isnumeric);
    
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
    
end