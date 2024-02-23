function ramp(obj, setp, rate)
    arguments
        obj
        setp (1,1) double = nan
        rate (1,1) double = obj.get('rampRate')
    end
    
    if isnan(setp)
        rate = obj.get('rampRate');
        isRampOn = obj.get('rampOn');
        obj.write(sprintf("RAMP %d, %d, %.2f", ...
            obj.loop, ~isRampOn, rate));
        return;
    end
    
    if rate < 0.1, rate = 0.1; end
    if rate > 100, rate = 100; end
    obj.rampRate = rate;

    disp("Ramping to " + setp + " at " + rate + " K/min");
    
    if obj.get('heaterRange') == 0
        obj.set('heaterRange', 4);
    end
    
    obj.write(sprintf("RAMP %d, 1, %f", obj.loop, rate));
    obj.set('S', setp);
end