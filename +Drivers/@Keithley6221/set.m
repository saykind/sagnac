function set(obj, options)
    %Parameter set method
    %
    %   Usage example:
    %   source.set('on', 1);

    arguments
        obj {mustBeA(obj, "Drivers.Keithley6221")}
        options.on (1, 1) double {mustBeNumeric} = NaN
        options.compliance (1, 1) double {mustBeNumeric} = NaN
        options.current (1, 1) double {mustBeNumeric} = NaN 
    end

    % on
    if ~isnan(options.on)
        obj.writef(":output %d", options.on);
    end
    
    % compliance
    if ~isnan(options.compliance)
        obj.writef(":sour:curr:comp %f", options.compliance);
    end

    % current
    if ~isnan(options.current)
        obj.writef(":sour:curr %f", options.current);
    end


end