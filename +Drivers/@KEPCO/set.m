function obj = set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   obj.set('voltage', 5);
    %   obj.set('current', .1);

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
    if ~isnan(parameters.output)
        obj.write(sprintf('OUTPUT %s', parameters.output));
    end
     
end