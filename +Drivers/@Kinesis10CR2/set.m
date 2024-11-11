function set(obj, options)
    %Parameter set method
    %
    %   Available parameters:
    %   - angle
    %
    %   Usage example:
    %   obj.set('angle', 180);

    arguments
        obj;
        % Input parameters
        options.angle double = [];
    end
    
    %% Set values
    if ~isempty(options.angle)
        obj.handle.MoveTo(options.angle, obj.timeout);
    end

end