function ramp_on = ramp(obj, setp, rate)
    arguments
        obj
        setp (1,1) double = nan
        rate (1,1) double = obj.get('ramp_rate')
    end
    
    if isnan(setp) % turn ramping on or off.
        ramp_on = obj.get('ramp_on');
        obj.write(sprintf("ramp %d, %d, %.2f", obj.loop, ~ramp_on, rate));
        ramp_on = double(~ramp_on);
        return;
    end
    
    if nargin > 2 % check that rate is within bounds
        if rate < 0.1, rate = 0.1; end
        if rate > 100, rate = 100; end
    end
    
    if obj.get('heater_range') == 0
        obj.set('heater_range', 5);
    end

    if obj.verbose
        disp("Ramping to " + setp + " at " + rate + " K/min");
    end

    ramp_on = 1;
    obj.writef("ramp %d, %d, %.2f", obj.loop, ramp_on, rate);
    obj.set('setpoint', setp);
end