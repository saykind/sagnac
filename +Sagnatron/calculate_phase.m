function phase = calculate_phase(v1x, v1y, v2)
    vx = v1x./v2;
    vy = v1y./v2;
    sx = mean(vx);
    sy = mean(vy);
    sxx = mean(vx.^2);
    sxy = mean(vx.*vy);
    syy = mean(vy.^2);
    phase = 0.5*atan(2*(sxy-sx*sy)/(sxx-syy+sy^2-sx^2));
end
