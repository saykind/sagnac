function obj = set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   obj.set('voltageLimit', 25);
    %   obj.set('V', 15);
    %   obj.set('I', .1);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'I', NaN, @isnumeric);
    addParameter(p, 'V', NaN, @isnumeric);
    addParameter(p, 'currentLimit', NaN, @isnumeric);
    addParameter(p, 'voltageLimit', NaN, @isnumeric);
    addParameter(p, 'output', NaN, @isnumeric);
    addParameter(p, 'coilConstant', NaN, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    if ~isnan(parameters.V)
        obj.V = parameters.V;
        obj.write(sprintf("VOLT %.4f", parameters.V));
    end
    if ~isnan(parameters.I)
        obj.I = parameters.I;
        obj.write(sprintf("CURR %.4f", parameters.I));
    end
    if ~isnan(parameters.output)
        obj.write(sprintf("OUTPUT %d", parameters.output));
    end
    if ~isnan(parameters.currentLimit)
        obj.currentLimit = parameters.currentLimit;
        obj.write(sprintf("CURRENT:LIMIT:HIGH %d", parameters.currentLimit));
    end
    if ~isnan(parameters.voltageLimit)
        obj.voltageLimit = parameters.voltageLimit;
        obj.write(sprintf("VOLTAGE:LIMIT:HIGH %d", parameters.voltageLimit));
    end
    % Internal parameters
    if ~isnan(parameters.coilConstant)
        obj.coilConstant = parameters.coilConstant;
    end
     
end