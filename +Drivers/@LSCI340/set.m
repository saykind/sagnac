function set(obj, options)
    %Parameter set method
    %
    %   Usage example:
    %   tempcont.set('S', 290);
    %   tempcont.set(S=290);

    arguments
        obj {mustBeA(obj, "Drivers.LSCI340")}
        % Parameters
        options.control_mode (1, :) char {mustBeMember(options.control_mode, ...
            {'', 'manual', 'zone', 'open', 'autotunePID', 'autotunePI', 'autotuneP'})} = ''
        options.control_enable (1, 1) double {mustBeNumeric} = NaN
        options.heater_range (1, 1) double {mustBeNumeric} = NaN
        options.manual_output (1, 1) double {mustBeNumeric} = NaN
        options.pid (1, 3) double {mustBeNumeric} = NaN
        options.ramp_on (1, 1) double {mustBeNumeric} = NaN
        options.ramp_rate (1, 1) double {mustBeNumeric} = NaN
        options.ramp_status (1, 1) double {mustBeNumeric} = NaN
        % Fields
        options.S (1, 1) double {mustBeNumeric} = NaN
    end
    
    % Control mode
    if ~isempty(options.control_mode)
        switch options.control_mode
            case 'manual'
                obj.write(sprintf("cmode %d, 1", obj.loop));
            case 'zone'
                obj.write(sprintf("cmode %d, 2", obj.loop));
            case 'open'
                obj.write(sprintf("cmode %d, 3", obj.loop));
            case 'autotunePID'
                obj.write(sprintf("cmode %d, 4", obj.loop));
            case 'autotunePI'
                obj.write(sprintf("cmode %d, 5", obj.loop));
            case 'autotuneP'
                obj.write(sprintf("cmode %d, 6", obj.loop));
        end
    end

    % Control enable
    if ~isnan(options.control_enable)
        if ~ismember(options.control_enable, [0, 1])
            error("Control enable must be 0 or 1.");
        end
        % The following command always assumes that control input is A, units are K,
        % and the control should be enabled at powerup.
        obj.write(sprintf("cset %d, A, 1, %d, 1", obj.loop, options.control_enable));
    end

    % Heater range
    if ~isnan(options.heater_range)
        obj.write(sprintf("range %d", options.heater_range));
    end
    
    % Manual output
    if ~isnan(options.manual_output)
        current = 100*options.manual_output; 
        % Current in percents of 1 A.
        if current < 0
            current = 0;
            warning("Manual output cannot be negative. Set to 0.");
        elseif current > 100
            current = 100;
            warning("Manual output cannot be greater than 100. Set to 100.");
        end
        obj.write(sprintf("mout %d, %.2f", obj.loop, current));
    end

    % PID
    if ~isnan(options.pid)
        obj.write(sprintf("pid 1, %.2f, %.2f, %.2f", options.pid(1), options.pid(2), options.pid(3)));
    end

    % Ramp on
    if ~isnan(options.ramp_on)
        obj.write(sprintf("ramp %d, %d", obj.loop, options.ramp_on));
    end

    % Ramp rate
    if ~isnan(options.ramp_rate)
        obj.write(sprintf("ramp %d, %d, %.2f", obj.loop, obj.ramp_on, options.ramp_rate));
    end
    
    % Setpoint
    if ~isnan(options.S)
        obj.write(sprintf("setp 1, %d", options.S));
    end
    
end