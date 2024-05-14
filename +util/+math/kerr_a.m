function kerr_angle = kerr_a(v1, v2, a, a0)
    %Computes Kerr angle in urad from first and second harmonics voltages and midulation amplitude
    %Assumes that both V1X and V2R are in the same units and scaled
    %in the same way (symmetric splitter).


    v1_ideal = besselj(1,1.841*a/a0);

    v2_ideal = abs(besselj(2,1.841*a/a0));

    kerr_angle = .5*atan2(v1.*v2_ideal.*sign(v1_ideal), v2.*abs(v1_ideal))*1e6;
end
