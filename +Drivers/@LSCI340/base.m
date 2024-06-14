function base(obj)
    %Ramp setpoint to base temperature quickly and turn heater off.
    obj.control_enable = 1;
    obj.control_mode = 'manual';
    obj.ramp(3, 10);
    obj.heater_range = 0;    
end