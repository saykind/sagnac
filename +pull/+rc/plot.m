function graphics = plot(graphics, logdata)
%Graphics plotting function.

    [ax_A, ax_B, ax_C] = util.unpack(graphics.axes);
    %for ax = [ax_temp_A, ax_temp_B]
    %    cla(ax);
    %end
    for ax = [ax_A, ax_B, ax_C]
        yyaxis(ax, 'left'); cla(ax);
        yyaxis(ax, 'right'); cla(ax);
    end

    temp = logdata.tempcont.A;
    % Transport
    curr = .1;                          % Current, A (effective)
    res = 1e3*logdata.lockinA.X/curr;   % Resistance, mOhm
    res_avg = mean(res);
    
    auxv1 = logdata.lockinA.AUXV1;  % Voltage in V    

    cap = logdata.bridge.C;             % Capacitance, pF
    [strain, d] = util.strain.from_capacitance(cap, temp, d0_sample=985);

    %coeff = 5.5e-5/3.26;  % Strain gauge coefficient in %/mV
    %strain = auxv1*coeff; % Strain in %
    

    yyaxis(ax_A, 'right');
    plot(ax_A, 25*auxv1, d, 'b-');
    yyaxis(ax_A, 'left');    
    plot(ax_A, 25*auxv1, strain, 'r-');

    yyaxis(ax_B, 'right');
    plot(ax_B, auxv1, cap, 'b-');
    yyaxis(ax_B, 'left');
    plot(ax_B, auxv1, res, 'r-');

    yyaxis(ax_C, 'right');
    plot(ax_C, strain, cap, 'b-');
    yyaxis(ax_C, 'left');
    plot(ax_C, strain, res, 'r-');

end