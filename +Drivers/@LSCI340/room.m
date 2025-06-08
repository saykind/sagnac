function room(obj)
    %Warmup to room temperature quickly.
    obj.control_enable = 1;
    obj.control_mode = 'manual';
    obj.heater_range = 4;
    obj.ramp(270, 5);
end