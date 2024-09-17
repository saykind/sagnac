function set(obj, options)
    %Parameter set method
    %
    %   Usage example:
    %   source.set('source.function', 'curr');
    %   source.set('sense.function', ['curr', 'volt']);
    %   source.set('sense.voltage.range', 10);
    %   source.set('sense.voltage.protection', 10);
    %   source.set('source.current.range', 1e-2);
    %   source.set('current.level', 5e-3);
    %   source.set('on', 1);

    arguments
        obj {mustBeA(obj, "Drivers.Keithley2401")}
        options.on (1, 1) double {mustBeNumeric} = NaN
        options.source_function (1, :) char = ''
        options.source_voltage_mode (1, :) char = ''
        options.source_voltage_level (1, 1) double {mustBeNumeric} = NaN
        options.source_voltage_range (1, 1) double {mustBeNumeric} = NaN
        options.source_current_mode (1, :) char = ''
        options.source_current_level (1, 1) double {mustBeNumeric} = NaN
        options.source_current_range (1, 1) double {mustBeNumeric} = NaN
        options.sense_function (1, :) string = ""
        options.sense_function_concurrent (1, 1) double {mustBeNumeric} = NaN
        options.sense_voltage_protection (1, 1) double {mustBeNumeric} = NaN
        options.sense_voltage_range (1, 1) double {mustBeNumeric} = NaN
        options.sense_current_protection (1, 1) double {mustBeNumeric} = NaN
        options.sense_current_range (1, 1) double {mustBeNumeric} = NaN    
    end

    % on
    if ~isnan(options.on)
        obj.writef(":output %d", options.on);
    end
    
    % source
    if ~isempty(options.source_function)
        switch lower(options.source_function)
            case {'voltage', 'volt', 'v'}
                obj.write(":source:function voltage");
            case {'current', 'curr', 'c'}
                obj.write(":source:function current");
        end
    end

    % source.voltage
    if ~isempty(options.source_voltage_mode)
        switch lower(options.source_voltage_mode)
            case {'fixed', 'fix', 'f'}
                obj.write(":source:voltage:mode fixed");
            case {'list', 'l'}
                obj.write(":source:voltage:mode list");
            case {'sweep', 's'}
                obj.write(":source:voltage:mode sweep");
        end
    end
    if ~isnan(options.source_voltage_level)
        obj.writef(":source:voltage:level %f", options.source_voltage_level);
    end
    if ~isnan(options.source_voltage_range)
        obj.writef(":source:voltage:range %f", options.source_voltage_range);
    end

    % source.current
    if ~isempty(options.source_current_mode)
        switch lower(options.source_current_mode)
            case {'fixed', 'fix', 'f'}
                obj.write(":source:current:mode fixed");
            case {'list', 'l'}
                obj.write(":source:current:mode list");
            case {'sweep', 's'}
                obj.write(":source:current:mode sweep");
        end
    end
    if ~isnan(options.source_current_level)
        obj.writef(":source:current:level %f", options.source_current_level);
    end
    if ~isnan(options.source_current_range)
        obj.writef(":source:current:range %f", options.source_current_range);
    end

    % sense
    if ~isempty(options.sense_function)
        for i = 1:length(options.sense_function)
            options.sense_function(i) = lower(options.sense_function(i));
        end
        possible_functions = ["volt", "curr", "res"];
        idx = ismember(possible_functions, options.sense_function);
        for func = possible_functions(idx)
            obj.writef(':sense:function "%s"', func);
        end
        for func = possible_functions(~idx)
            obj.writef(':sense:function:off "%s"', func);
        end
    end
    if ~isnan(options.sense_function_concurrent)
        obj.writef(":sense:function:concurrent %f", options.sense_function_concurrent);
    end

    % sense.voltage
    if ~isnan(options.sense_voltage_protection)
        obj.writef(":sense:voltage:protection %f", options.sense_voltage_protection);
    end
    if ~isnan(options.sense_voltage_range)
        obj.writef(":sense:voltage:range %f", options.sense_voltage_range);
    end

    % sense.current
    if ~isnan(options.sense_current_protection)
        obj.writef(":sense:current:protection %f", options.sense_current_protection);
    end
    if ~isnan(options.sense_current_range)
        obj.writef(":sense:current:range %f", options.sense_current_range);
    end


end