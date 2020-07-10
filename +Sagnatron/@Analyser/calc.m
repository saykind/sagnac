function [phase, offset] = calc(obj)
    %Parameter calculation method
    %   Calculates phase shift between first and second harmonic
    %   as well as the related constant kerr angle shift
    %   based on the given offset temperature range.
    
    % Collect data
    v1x = obj.data.first;
    v1y = obj.data.firstY;
    v2 = obj.data.second;
    temp = obj.data.temperature;
    
    % Find offset data points
    range = obj.offsetRange;
    idx = find(temp > range(1) & temp < range(2));
    
    % Calculate phase shift between first and second harmonics
    % and kerr angle offset
    phase = Sagnatron.calculate_phase(v1x(idx), v1y(idx), v2(idx));
    offset = mean(kerr(idx));
    
    obj.phase = phase;
    obj.offset = offset;
    
    if obj.verbose
        fprintf("phase \t= %.2f deg\n", rad2deg(phase));
        fprintf("offset \t= %.2f \murad\n", offset);
    end
end