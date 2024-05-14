function set(obj, options)
    %Parameter set method

    arguments
        obj {mustBeA(obj, "Drivers.BCB")}
        options.mode (1, :) char {mustBeMember(options.mode, ...
            {'', 'Q+', 'q+', 'Q-', 'q-', ...
             'MAX', 'Max', 'max', 'MIN', 'Min', 'min', ...
             'MANUAL', 'Manual', 'manual'})} = ''
        options.voltage (1, 1) double {mustBeNumeric} = NaN
        options.vpi (1, 1) double {mustBeNumeric} = NaN
    end
    
    % Mode
    if ~isempty(options.mode)
        switch options.mode
            case {'Q+', 'q+'}
                mode = 1;
            case {'Q-', 'q-'}
                mode = 2;
            case {'MAX', 'Max', 'max'}
                mode = 3;
            case {'MIN', 'Min', 'min'}
                mode = 4;
            case {'MANUAL', 'Manual', 'manual'}
                mode = 5;
            otherwise
                mode = NaN;
                util.msg("Invalid mode.");
        end
        if ~isnan(mode)
            obj.writef("SET%dM:%d", obj.add, mode);
        end
    end

    % Voltage
    if ~isnan(options.voltage)
        % Check if voltage is within limits
        if options.voltage > obj.voltage_max 
            voltage = obj.voltage_max;
            util.msg("Voltage exceeds maximum limit.");
        elseif options.voltage < obj.voltage_min
            voltage = obj.voltage_min;
            util.msg("Voltage exceeds minimum limit.");
        else
            voltage = options.voltage;
        end

        % Check if BCB is in manual mode
        if ~strcmp(obj.mode, "Manual")
            util.msg("BCB is not in manual mode.");
            return
        end

        voltage_span = obj.voltage_max - obj.voltage_min;
        value = fix(16382 * (obj.voltage_max - voltage) / voltage_span);
        reply = obj.queryf("SET%dV:%d", obj.add, value);
        if ~contains(reply, "Successful")
            util.msg("Failed to set voltage.");
        end
    end

    % VPI
    if ~isnan(options.vpi)
        value = fix(options.vpi / obj.voltage_coeff);
        reply = obj.queryf("SET%dVPI:%d", obj.add, value);
        if ~contains(reply, "Successful")
            util.msg("Failed to set V pi.");
        end
    end
   
end