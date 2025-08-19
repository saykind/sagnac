function graphics = fa(graphics, logdata, options)
    %Graphics plotting function.
    
    arguments
        graphics struct;
        logdata struct;
        options.resp_dc (1,1) double = 1; 
        options.resp_ac (1,1) double = 1; 
        options.sls (1,1) double = .1; 
    end
        resp_dc = options.resp_dc;
        resp_ac = options.resp_ac;
        sls = options.sls;
    
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        cla(axisA);
        cla(axisB);

        ampl = logdata.waveform.ampl;           % Amplitude Vpp, V
        freq = logdata.waveform.freq*1e-6;      % Frequency, Hz
        P0  = 1e3*logdata.voltmeter.v1/resp_dc; % DC Power, uW
        P0 = abs(P0);
        PX = 1e3*logdata.lockin.X/resp_ac;      % AC Power X, uW
        PY = 1e3*logdata.lockin.Y/resp_ac;      % AC Power Y, uW
        PR  = 1e3*logdata.lockin.R/resp_ac;     % AC Power R, uW
        PQ = logdata.lockin.Q;                  % Ac Power Q, deg
        
        %P2X = sls*logdata.lockin.AUX1/resp_ac;      % AC Power X, uW
        %P2Y = sls*logdata.lockin.AUX2/resp_ac;      % AC Power X, uW
        %P2 = sqrt(P2X.^2+P2Y.^2);
        
        shape = logdata.sweep.shape;
        f = logdata.sweep.range(1,:)*1e-6;
        a = logdata.sweep.range(2,:);
        F = util.mesh.combine(f, shape);
        A = util.mesh.combine(a, shape);
        n0 = length(logdata.sweep.range);
        n_curr = length(P0);
        
        p0 = zeros(1, n0);
        p0(1:n_curr) = P0;
        p0(n_curr:end) = p0(1);
        P0 = util.mesh.combine(p0, shape);
        
        pR = zeros(1, n0);
        pR(1:n_curr) = PR;
        pR(n_curr:end) = pR(1);
        PR = util.mesh.combine(pR, shape);
        
        surf(axisA, F, A, P0, 'EdgeAlpha', .1);
        surf(axisB, F, A, PR, 'EdgeAlpha', .1); 
        %xlim(axisA, [4.4, 5.2]);
        %xlim(axisB, [4.4, 5.2]);
        %try contourf instead of surf?