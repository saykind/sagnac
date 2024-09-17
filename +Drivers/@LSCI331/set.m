function set(obj, options)
    %Parameter set method
    %
    %   Usage example:
    %   tempcont.set('mode', 4);
    %   tempcont.set('pid', [3 50 100], heater_range=3);

    arguments
        obj {mustBeA(obj, "Drivers.LSCI331")}
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
        options.setpoint (1, 1) double {mustBeNumeric} = NaN
    end

    % Control mode
    if ~isempty(options.control_mode)
        %remove spaces
        switch strrep(lower(options.control_mode), ' ', '')
            case {'manual', 'manualpid'}
                obj.writef("cmode %d, 1", obj.loop);
            case 'zone'
                obj.writef("cmode %d, 2", obj.loop);
            case {'open', 'openloop'}
                obj.writef("cmode %d, 3", obj.loop);
            case {'pid', 'autopid', 'autotunepid'}
                obj.writef("cmode %d, 4", obj.loop);
            case {'pi', 'autopi', 'autotunepi'}
                obj.writef("cmode %d, 5", obj.loop);
            case {'p', 'autop', 'autotunep'}
                obj.writef("cmode %d, 6", obj.loop);
            otherwise
                util.msg("Control mode must be one of the following: 'manual', 'zone', 'open', 'auto PID', 'auto PI', 'auto P'.");
        end
    end

    % Control enable
    if ~isnan(options.control_enable)
        if ~ismember(options.control_enable, [0, 1])
            util.msg("Control enable must be 0 or 1.");
        end
        % The following command always assumes that control input is A, units are K,
        % and the control should be enabled at powerup.
        obj.writef("cset %d, A, 1, %d, 1", obj.loop, options.control_enable);
    end

    % Heater range
    if ~isnan(options.heater_range)
        obj.writef("range %d", options.heater_range);
    end
    
    % Manual output
    if ~isnan(options.manual_output)
        current = 100*options.manual_output; 
        % Current in percents of 1 A.
        if current < 0
            current = 0;
            util.msg("Manual output cannot be negative. Set to 0.");
        elseif current > 100
            current = 100;
            util.msg("Manual output cannot be greater than 100. Set to 100.");
        end
        obj.writef("mout %d, %.2f", obj.loop, current);
    end

    % PID
    if ~isnan(options.pid)
        p = options.pid(1);
        i = options.pid(2);
        d = options.pid(3);
        if p < 0.1,  p = 0.1;  end
        if p > 1000, p = 1000; end
        if i < 0.1,  i = 0.1;  end
        if i > 1000, i = 1000; end
        if d < 0,    d = 0;    end
        if d > 200,  d = 200;  end
        obj.writef("pid %d, %.2f, %.2f, %.2f", obj.loop, p, i, d);
    end

    % Ramp on
    if ~isnan(options.ramp_on)
        obj.writef("ramp %d, %d", obj.loop, options.ramp_on);
    end

    % Ramp rate
    if ~isnan(options.ramp_rate)
        obj.writef("ramp %d, %d, %.2f", obj.loop, obj.ramp_on, options.ramp_rate);
    end
    
    % Setpoint
    if ~isnan(options.setpoint)
        obj.writef("setp 1, %f", options.setpoint);
    end

end