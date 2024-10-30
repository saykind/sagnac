function graphics = zkg(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.dT (1,1) double = 0;
end

        [axisA, axisB, axisC, ...
            axisTtA, axisTtB, ...
            axisGA, axisGB, axisGC, ...
            axisT, ...
            axisPa, axisPb, ...
            axisTrA, ...
            axisTrB ...
            ] = util.unpack(graphics.axes);
        for ax = graphics.axes
            yyaxis(ax, 'right'); cla(ax); 
            yyaxis(ax, 'left'); cla(ax);
        end

        t = logdata.timer.time/60;          % Time, min
        v = logdata.source.V;               % Gate voltage, V
        i = 1e9*logdata.source.I;           % Gate leakadge current, nA
        tA = logdata.tempcont.A;            % Temp A, K
        tB = logdata.tempcont.B;            % Temp B, K
        dc = 1e3*logdata.voltmeter.v1;      % DC voltage, mV
        vAx = 1e9*logdata.lockinA.X;        % Lockin A V_X, nA
        vBx = 1e6*logdata.lockinB.X;        % Lockin A V_X, mV
        
        [v1x, v1y, v2x, v2y, ~, v2, kerr] = util.logdata.lockin(logdata.lockin);
        
        % Average datapoints
        n = numel(kerr);
        k = logdata.sweep.rate-logdata.sweep.pause;
        k = k(1);   %FIXME
        m = fix(n/k);
        %fprintf("kerr_mean = %.3f\n", mean(kerr));
        if m*k ~= n
            disp("m*k != n");
            fprintf("%d*%d != %d", m ,k ,n);
            V = v;
            K = kerr;
            K_std = zeros(size(kerr));
            DC = dc;
            V1x = v1x;
            V1y = v1y;
            V2x = v2x;
            V2y = v2y;
            V2 = v2;
            VAx = vAx;
            VBx = vBx;
            I = i;
        else
            V = mean(reshape(v, [k, m]), 1);
            K = mean(reshape(kerr, [k, m]), 1);
            K_std = std(reshape(kerr, [k, m]), 0, 1);
            DC = mean(reshape(dc, [k, m]), 1);
            V1x = mean(reshape(v1x, [k, m]), 1);
            V1y = mean(reshape(v1y, [k, m]), 1);
            V2x = mean(reshape(v2x, [k, m]), 1);
            V2y = mean(reshape(v2y, [k, m]), 1);
            V2 = mean(reshape(v2, [k, m]), 1);
            VAx = mean(reshape(vAx, [k, m]), 1);
            VBx = mean(reshape(vBx, [k, m]), 1);
            I = mean(reshape(i, [k, m]), 1);
        end

        % Kerr vs Time
        yyaxis(axisA, 'left');
        plot(axisA, t, kerr, 'Color', 'r');
        yyaxis(axisA, 'right');
        plot(axisA, t, dc, 'Color', 'b');
        yyaxis(axisA, 'left');

        yyaxis(axisB, 'left');
        plot(axisB, t, v1x, 'Color', 'r');
        yyaxis(axisB, 'right');
        plot(axisB, t, v1y, 'Color', 'b');

        yyaxis(axisC, 'left');
        plot(axisC, t, v2x, 'Color', 'r');
        plot(axisC, t, v2, 'k-');
        yyaxis(axisC, 'right');
        plot(axisC, t, v2y, 'Color', 'b');

        % Temp vs Time
        yyaxis(axisTtA, 'left');
        plot(axisTtA, t, tA, 'Color', 'r');
        yyaxis(axisTtA, 'right');
        plot(axisTtA, t, tB, 'Color', 'b');

        % Kerr vs Gate A
        yyaxis(axisGA, 'left');
        errorbar(axisGA, V, K, K_std, 'Color', 'r');
        yyaxis(axisGA, 'right');
        plot(axisGA, V, DC, 'Color', 'b');

        yyaxis(axisGB, 'left');
        plot(axisGB, V, V1x, 'Color', 'r');
        yyaxis(axisGB, 'right');
        plot(axisGB, V, V1y, 'Color', 'b');

        yyaxis(axisGC, 'left');
        plot(axisGC, V, V2, 'r-');
        yyaxis(axisGC, 'right');
        plot(axisGC, V, DC, 'Color', 'b');
        
        % Kerr vs Temp B
        yyaxis(axisT, 'left');
        plot(axisT, tA, kerr, 'Color', 'r');
        yyaxis(axisT, 'right');
        plot(axisT, tA, dc, 'Color', 'b');

        % Kerr vs Power
        yyaxis(axisPa, 'left');
        plot(axisPa, dc, kerr, 'r.');
        yyaxis(axisPa, 'right');

        yyaxis(axisPb, 'left');
        plot(axisPb, v2, kerr, 'r.');
        yyaxis(axisPb, 'right');
        
        % Transport
        yyaxis(axisTrA, 'left');
        plot(axisTrA, V, VAx, 'Color', 'r');
        yyaxis(axisTrA, 'right');
        plot(axisTrA, V, I, 'Color', 'b');
        plot(axisTrA, v, i, 'b.');
        
        plot(axisTrB, v, vBx./vAx, 'Color', 'r');
    
end