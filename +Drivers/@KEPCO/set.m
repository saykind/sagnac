function obj = set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   obj.set('V', 5);
    %   obj.set('I', .1);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'I', NaN, @isnumeric);
    addParameter(p, 'V', NaN, @isnumeric);
    addParameter(p, 'output', '', @ischar);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    if ~isnan(parameters.V)
        obj.write(sprintf( "VOLT %.4f", parameters.V));
    end
    if ~isnan(parameters.I)
        obj.write(sprintf( "CURR %.4f", parameters.I));
    end
    if ~isempty(parameters.output)
        obj.write(sprintf('OUTPUT %s', parameters.output));
    end
     
end