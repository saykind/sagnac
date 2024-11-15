function set(obj, options)
    %Parameter set method
    %
    %   Available parameters:
    %   - angle
    %   - velocity
    %
    %   Usage example:
    %   obj.set('v', 5);
    %   obj.set('angle', 180);

    arguments
        obj;
        % Parameters
        options.velocity double = [];
        options.acceleration double = [];
        options.angle double = [];
    end
    
    % Velocity
    if ~isempty(options.velocity)
        obj.handle.SetVelocityParams(options.velocity, obj.acceleration);
    end

    % Acceleration
    if ~isempty(options.acceleration)
        obj.handle.SetVelocityParams(obj.velocity, options.acceleration);
    end

    % Angle
    if ~isempty(options.angle)
        obj.handle.MoveTo(options.angle, obj.timeout);
    end

end