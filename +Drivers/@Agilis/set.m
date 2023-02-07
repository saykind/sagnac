function out = set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   obj.set('voltage', 5);
    %   obj.set('current', .1);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'hometype', NaN, @isnumeric);
    addParameter(p, 'position', NaN, @isnumeric);
    addParameter(p, 'neglim', NaN, @isnumeric);
    addParameter(p, 'poslim', NaN, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    if ~isnan(parameters.hometype)
        if parameters.hometype == 1
            obj.write("1HT1");
        elseif parameters.hometype == 4
            obj.write("1HT4");
        else
            disp("Only 1 or 4 home search type are allowed.")
        end
    end
    if ~isnan(parameters.position)
        obj.write(sprintf("1PA%.4f", parameters.position));
        if obj.wait
            for i=1:200
                java.lang.Thread.sleep(100); % 15 millisec accuracy
                if ~strcmp(obj.st(), "MOVING")
                    break
                end
            end
            obj.st();
            obj.ps();
        end
    end
    if ~isnan(parameters.neglim)
        %if parameters.neglim > 0
        %    error("Negative limit has to be negative.")
        %end
        obj.write(sprintf("1SL%d", parameters.neglim));
    end
    if ~isnan(parameters.poslim)
        if parameters.poslim < 0
            error("Positive limit has to be positive.")
        end
        obj.write(sprintf("1SR%d", parameters.poslim));
    end
    out = obj.get('error');
end