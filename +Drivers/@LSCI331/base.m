function base(obj)
    %Ramp setpoint to base temperature quickly and turn heater off.
    obj.ramp_on = 0;
    obj.setpoint = 2;
    obj.ramp_on = 1;
    obj.heater_range = 0;    
end