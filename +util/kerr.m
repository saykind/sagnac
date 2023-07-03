function kerr_angle = kerr(v1, v2)
    %Computes Kerr angle in urad from first and second harmonics voltages. 
    %Assumes that both V1X and V2R are in the same units and scaled
    %in the same way (symmetric splitter).
    c = besselj(2,1.841)/besselj(1,1.841);
    kerr_angle = .5*atan(c*v1./v2)*1e6;
    %Factor 1/2 is needed since in reflection 2*\theta_K is measured.
end
