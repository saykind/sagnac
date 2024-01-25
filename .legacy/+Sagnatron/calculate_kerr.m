function kerr_angle = calculate_kerr(v1, v2)
    %Computes Kerr angle in urad from first (uV) and second harmonics (V) data
    c = besselj(2,1.841)/besselj(1,1.841);
    kerr_angle = .5*atan(c*(v1*1e-6)./v2)*1e6;
end
