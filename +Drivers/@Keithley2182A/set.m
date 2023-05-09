function set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   voltmeter.set('range', 0);
    %   voltmeter.set('channel', 1);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'channel', NaN, @(x) (x==1) || (x==2));
    addParameter(p, 'range', NaN, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    if ~isnan(parameters.channel)
        ch = parameters.channel;
        obj.write(sprintf(":sense:channel %d", ch));
        obj.channel = ch;
    end
    if ~isnan(parameters.range)
        r = parameters.range;
        if r == 0
            obj.write(sprintf(":sense:voltage:channel%d:range:auto on", obj.channel));
        else
            obj.write(sprintf(":sense:voltage:channel%d:range %f", obj.channel, r));
        end
        obj.range = r;
    end
end