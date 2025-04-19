function set(obj, options)
    %Parameter set method
    %
    %   Available parameters:
    %   - angle
    %   - velocity
    %
    %   Usage example:
    %   obj.set('v', 5);
    %   obj.set('position', 1);

    arguments
        obj;
        % Parameters
        options.velocity double = [];
        options.acceleration double = [];
        options.backlash double = [];
        options.position double = [];
    end
    
    % Velocity
    if ~isempty(options.velocity)
        obj.handle.SetVelocityParams(options.velocity, obj.acceleration);
    end

    % Acceleration
    if ~isempty(options.acceleration)
        obj.handle.SetVelocityParams(obj.velocity, options.acceleration);
    end

    % Backlash
    if ~isempty(options.backlash)
        obj.handle.SetBacklash(options.backlash);
    end

    % Angle
    if ~isempty(options.position)
        timeout = 0;
        obj.handle.MoveTo(options.position, timeout);
    end

end