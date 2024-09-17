function graphics = zcs(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.dT (1,1) double = 0;
    options.x1_offset (1,1) double = 0; 
    options.curr2dens (1,1) double = .6;   % 10^6 A/cm2 (1 mA --> .6e6 A/cm2)
end    

    [axisA, axisB, axisC] = util.unpack(graphics.axes);
    for ax = graphics.axes
        yyaxis(ax, 'right'); cla(ax); 
        yyaxis(ax, 'left'); cla(ax);
    end

    I   = 1e3*logdata.source.current;   % Curr, mA
    v0  = 1e3*logdata.voltmeter.v1;     % DC Volt, mV
    [x1, y1, x2, y2, r1, r2, kerr] = util.logdata.lockin(logdata.lockin, 'x1_offset', options.x1_offset);
    
    n = numel(kerr);
    k = logdata.sweep.rate-logdata.sweep.pause;
    k = k(1);
    m = fix(n/k);
    KERR = mean(reshape(kerr, [k, m]),1);
    KERRstd = std(reshape(kerr, [k, m]),0,1);
    CURR = mean(reshape(I, [k, m]),1);
    V0 = mean(reshape(v0, [k, m]),1);
    
    % Sample at the top of the magnet
    % 25 mT/A
    CURR = CURR*options.curr2dens;

    yyaxis(axisA, 'left');
    % plot(axisA, CURR, KERR, 'r.-');
    errorbar(axisA, CURR, KERR, KERRstd, 'r.-', 'MarkerSize', 5);
    yyaxis(axisA, 'right');
    plot(axisA, CURR, V0, 'b.-');
    xlabel(axisA, 'Current density, 10^6 A/cm^2');

    yyaxis(axisB, 'left');
    plot(axisB, I, x1, 'r');
    yyaxis(axisB, 'right');
    plot(axisB, I, y1, 'b');

    yyaxis(axisC, 'left');
    plot(axisC, I, x2, 'r');
    yyaxis(axisC, 'right');
    plot(axisC, I, y2, 'b');

end