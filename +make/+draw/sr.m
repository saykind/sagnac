function graphics = sr(graphics, logdata)
%Graphics plotting function.

    axisA = graphics.axes(1);
    axisB = graphics.axes(2);
    cla(axisA); cla(axisB);

    curr = .1;  % Current in A
    coeff = 5.5e-5/3.26;  % Strain gauge coefficient in %/mV
    auxv1 = 1e3*logdata.lockin.AUXV1;  % Voltage in mV
    strain = auxv1*coeff; % Strain in %
    res = 1e3*logdata.lockin.X / curr;  % Resistance in mOhm
    res_avg = mean(res);
    
    if isfield(logdata, 'tempcont')
        temp = logdata.tempcont.A;
        plot(axisA, strain, (res/res_avg-1)*100, 'Color', 'r');
        plot(axisB, auxv1, temp, 'Color', 'b');
    else
        plot(axisA, auxv1, res, 'Color', 'r');
        %plot(axisB, strain, res, 'Color', 'b');
    end

    %set(axisA, 'XLim', [min(auxv1), max(auxv1)], ...
    %    'XTick', linspace(min(auxv1), max(auxv1), 7));
    %set(axisB, 'XLim', [min(strain), max(strain)], ...
    %    'XTick', linspace(min(strain), max(strain), 7));
    
end