function graphics = graphics(seed, graphics, logdata, varargin)
%Graphics initialization and plotting function.
%   Seed selects pre-defined experiment setups.
%   When nargin = 1, figure is created.
%   When nargin > 1, plot is made.
%
%   See also:
%       make.key();


%% Header
if nargin < 1, error("[make.graphics] Please provide seed/key."); end

% parse parameters
p = inputParser;
addParameter(p, 'title', [], @ischar);
addParameter(p, 'interactive', false, @islogical);
parse(p, varargin{:});
parameters = p.Results;

% Covert seed to key
if isnumeric(seed)
    key = seed;
    seedname = '';
else
    [key, seedname] = make.key(seed);
end
key = make.key(key);

% Select plot title
if ~isempty(parameters.title)
    plottitle = parameters.title;
elseif ~isempty(seedname)
    plottitle = seedname;
else
    plottitle = make.title(seed);
end

%% Create graphics
if nargin == 1
    
    graphics = make.graphics_init(key);
    set(graphics.figure, 'Name', plottitle);
    
    if parameters.interactive
        for i = 1:numel(graphics.axes), disableDefaultInteractivity(a(i)); end
    end
    
    return
end

%% Given graphics, draw a plot    
switch key
    case 84     % T : time vs Temperature
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        cla(axisA); cla(axisB);

        t = logdata.timer.time/60;
        d = datetime(logdata.timer.datetime);
        %t = (1:numel(logdata.timer.time(:,1)));
        %t = t/60;
        %d = datetime(logdata.timer.time);
        TA = logdata.tempcont.A;
        TB = logdata.tempcont.B;

        plot(axisA, t, TA, 'Color', 'r');
        plot(axisB, d, TB, 'Color', 'b');

        set(axisA, 'XLim', [min(t), max(t)], ...
            'XTick', linspace(min(t), max(t), 7));
        set(axisB, 'XLim', [min(d), max(d)], ...
            'XTick', linspace(min(d), max(d), 7));

    case 12412  % tk : time vs Kerr
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        axisC = graphics.axes(3);
        for axis = graphics.axes
            yyaxis(axis, 'right'); cla(axis); 
            yyaxis(axis, 'left'); cla(axis);
        end

        sls = .1;  % second lockin sensitivity

        t = logdata.timer.time/60;          % Time, min
        dc = 1e3*logdata.voltmeter.v1;      % DC voltage, mV
        V1X = 1e6*logdata.lockin.X;         % 1st harm Voltage X, uV
        V1Y = 1e6*logdata.lockin.Y;         % 1st harm Voltage Y, uV
        V2X = sls*1e3*logdata.lockin.AUX1;  % 2nd harm Voltage X, mV
        V2Y = sls*1e3*logdata.lockin.AUX2;  % 2nd harm Voltage Y, mV

        V2 = sqrt(V2X.^2+V2Y.^2);
        kerr = util.kerr(V1X*1e-3, V2);

        % Kerr vs Time
        yyaxis(axisA, 'left');
        plot(axisA, t, kerr, 'Color', 'r');
        yyaxis(axisA, 'right');
        plot(axisA, t, dc, 'Color', 'b');

        yyaxis(axisB, 'left');
        plot(axisB, t, V1X, 'Color', 'r');
        yyaxis(axisB, 'right');
        plot(axisB, t, V1Y, 'Color', 'b');

        yyaxis(axisC, 'left');
        plot(axisC, t, V2X, 'Color', 'r');
        plot(axisC, t, V2, 'k-');
        yyaxis(axisC, 'right');
        plot(axisC, t, V2Y, 'Color', 'b');


    case 11600 % td : dc voltage (time only)
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        axisC = graphics.axes(3);
        for axis = graphics.axes
            yyaxis(axis, 'right'); cla(axis); 
            yyaxis(axis, 'left'); cla(axis);
        end

        sls = .26;                      % Second lockin sens, V
        t = logdata.timer.time/60;      % Time, min
        dc = 1e3*logdata.voltmeter.v1;  % DC voltage, mV
        V2X = 1e3*logdata.lockin.X;     % 2nd harm Voltage X, uV
        V2Y = 1e3*logdata.lockin.Y;     % 2nd harm Voltage Y, uV
        V2R = 1e3*logdata.lockin.R;     % 2nd harm Voltage X, uV

        % New Focus 1601, 830 nm
        %sensitivity = 4.7;  %V/mW
        % New Focus 1801, 830 nm
        %sensitivity = .47;  %V/mW
        % New Focus 1811, 1550 nm
        sensitivity = 10*1.04;  %V/mW
        sensitivity_ac = 40*1.04;  %V/mW
        % Thorlabs PDA100A2 , 830 nm
        %sensitivity = 1e-3*1.51*1e3*0.63;  %V/mW

        P0 = dc/sensitivity;
        P2 = V2R/sensitivity_ac;

        % Kerr vs Time
        yyaxis(axisA, 'left');
        plot(axisA, t, dc, 'Color', 'k');
        yyaxis(axisA, 'right');
        plot(axisA, t, P0, 'k', 'LineStyle','none');

        yyaxis(axisB, 'left');
        plot(axisB, t, V2X, 'Color', 'r');
        yyaxis(axisB, 'right');
        plot(axisB, t, V2Y, 'Color', 'b');

        yyaxis(axisC, 'left');
        plot(axisC, t, P2, 'r');
        yyaxis(axisC, 'right');
        plot(axisC, t, P2./P0, 'Color', 'b');

    case 107    %k: Kerr effect (main)
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        axisC = graphics.axes(3);
        axisTtA = graphics.axes(4);
        axisTtB = graphics.axes(5);
        axisTA = graphics.axes(6);
        axisTB = graphics.axes(7);
        axisTC = graphics.axes(8);
        axisTBA = graphics.axes(9);
        axisPa = graphics.axes(10);
        axisPb = graphics.axes(11);
        cla(axisA); yyaxis(axisA, 'left'); cla(axisA);
        cla(axisB); yyaxis(axisB, 'left'); cla(axisB);
        cla(axisC); yyaxis(axisC, 'left'); cla(axisC);
        cla(axisTtA); yyaxis(axisTtA, 'left'); cla(axisTtA);
        cla(axisTtB); yyaxis(axisTtB, 'left'); cla(axisTtB);
        cla(axisTA); yyaxis(axisTA, 'left'); cla(axisTA);
        cla(axisTB); yyaxis(axisTB, 'left'); cla(axisTB);
        cla(axisTC); yyaxis(axisTC, 'left'); cla(axisTC);
        cla(axisTBA); yyaxis(axisTBA, 'left'); cla(axisTBA);
        cla(axisPa); yyaxis(axisPa, 'left'); cla(axisPa);
        cla(axisPb); yyaxis(axisPb, 'left'); cla(axisPb);

        sls = .1;  % second lockin sensitivity

        t = logdata.timer.time/60;      % Time, min
        TA = logdata.tempcont.A;         % Temp, K
        TB = logdata.tempcont.B;         % Temp, K
        dc = 1e3*logdata.voltmeter.v1;  % DC voltage, mV
        V1X = 1e6*logdata.lockin.X;     % 1st harm Voltage X, uV
        V1Y = 1e6*logdata.lockin.Y;     % 1st harm Voltage Y, uV
        V2X = sls*1e3*logdata.lockin.AUX1;  % 2nd harm Voltage X, mV
        V2Y = sls*1e3*logdata.lockin.AUX2;  % 2nd harm Voltage Y, mV

        V2 = sqrt(V2X.^2+V2Y.^2);
        kerr = util.kerr(V1X*1e-3, V2);

        % Kerr vs Time
        yyaxis(axisA, 'left');
        plot(axisA, t, kerr, 'Color', 'r');
        yyaxis(axisA, 'right');
        plot(axisA, t, dc, 'Color', 'b');

        yyaxis(axisB, 'left');
        plot(axisB, t, V1X, 'Color', 'r');
        yyaxis(axisB, 'right');
        plot(axisB, t, V1Y, 'Color', 'b');

        yyaxis(axisC, 'left');
        plot(axisC, t, V2X, 'Color', 'r');
        plot(axisC, t, V2, 'k-');
        yyaxis(axisC, 'right');
        plot(axisC, t, V2Y, 'Color', 'b');

        % Temp vs Time
        yyaxis(axisTtA, 'left');
        plot(axisTtA, t, TA, 'Color', 'r');
        yyaxis(axisTtA, 'right');
        plot(axisTtA, t, TB, 'Color', 'b');

        % Kerr vs Temp A
        yyaxis(axisTA, 'left');
        plot(axisTA, TA, kerr, 'Color', 'r');
        yyaxis(axisTA, 'right');
        plot(axisTA, TA, dc, 'Color', 'b');

        yyaxis(axisTB, 'left');
        plot(axisTB, TA, V1X, 'Color', 'r');
        yyaxis(axisTB, 'right');
        plot(axisTB, TA, V1Y, 'Color', 'b');

        yyaxis(axisTC, 'left');
        plot(axisTC, TA, V2X, 'Color', 'r');
        plot(axisTC, TA, V2, 'k-');
        yyaxis(axisTC, 'right');
        plot(axisTC, TA, V2Y, 'Color', 'b');

        % Kerr vs Temp B
        yyaxis(axisTBA, 'left');
        plot(axisTBA, TB, kerr, 'Color', 'r');
        yyaxis(axisTBA, 'right');
        plot(axisTBA, TB, dc, 'Color', 'b');

        % Kerr vs Power
        yyaxis(axisPa, 'left');
        plot(axisPa, dc, kerr, 'r.');
        yyaxis(axisPa, 'right');

        yyaxis(axisPb, 'left');
        plot(axisPb, V2, kerr, 'r.');
        yyaxis(axisPb, 'right');

    case 102    %f: Mod freq sweep
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        axisC = graphics.axes(3);
        for axis = graphics.axes
            yyaxis(axis, 'right'); cla(axis); 
            yyaxis(axis, 'left'); cla(axis);
        end

        %sls = .25;  % second lockin sensitivity
        %sls = 1e-3;
        responsivity_dc = 10*1.04;   %   V/mW
        responsivity_ac = 40*1.04;   %   V/mW

        f   = logdata.waveform.freq*1e-6;               % Freq, MHz
        P0  = 1e3*logdata.voltmeter.v1/responsivity_dc; % DC Power, uW
        P2X = 1e3*logdata.lockin.X/responsivity_ac;     % 2nd harm Power X, uW
        P2Y = 1e3*logdata.lockin.Y/responsivity_ac;     % 2nd harm Power Y, uW
        P2  = 1e3*logdata.lockin.R/responsivity_ac;     % 2nd harm Power R, uW
        P2Q = logdata.lockin.Q;                         % 2nd harm Power Q, deg

        yyaxis(axisA, 'left');
        plot(axisA, f, P2./P0, 'r.-');
        f0 = 4.838;
        a = 2.7;
        a0 = 1.2;
        phi0 = 0.92*a/a0;
        p0 = 1+besselj(0,2*phi0*sin(pi/2*f/f0));
        p2 = 2*besselj(2,2*phi0*sin(pi/2*f/f0));
        plot(axisA, f, 4*p2./p0, 'r--');    %FIXME

        yyaxis(axisA, 'right');
        plot(axisA, f, P0, 'b.-');
        plot(axisA, f, P0(1)/2*p0, 'b--');

        yyaxis(axisB, 'left');
        plot(axisB, f, P2, 'r.');
        yyaxis(axisB, 'right');
        plot(axisB, f, P2Q,'b.');

        yyaxis(axisC, 'left');
        plot(axisC, f, P2X, 'r.');
        yyaxis(axisC, 'right');
        plot(axisC, f, P2Y, 'b.');



    case 97     %a: Modulation amplitude sweep
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        axisC = graphics.axes(3);
        for axis = graphics.axes
            yyaxis(axis, 'right'); cla(axis); 
            yyaxis(axis, 'left'); cla(axis);
        end

        sls = .26;  % second lockin sensitivity
        splitter = .673;
        %sls = 1e-3;
        responsivity_dc = 10*1.04;   %   V/mW
        responsivity_ac = 40*1.04;   %   V/mW

        a   = logdata.waveform.ampl;                            % Amplitude Vpp, V
        P0  = 1e3*logdata.voltmeter.v1/responsivity_dc;         % DC Power, uW
        P1X = 1e3*logdata.lockin.X/splitter/responsivity_ac;    % 2nd harm Power X, uW
        P1Y = 1e3*logdata.lockin.Y/splitter/responsivity_ac;    % 2nd harm Power Y, uW
        P2  = 1e3*logdata.lockin.R/splitter/responsivity_ac;    % 2nd harm Power R, uW
        P2Q = logdata.lockin.Q;                                 % 2nd harm Power Q, deg

        yyaxis(axisA, 'left');
        plot(axisA, a, abs(P2./P0), 'r.-');
        plot(axisA, a, abs(P2)/5, 'g.-');
        
        f0 = 4.838;
        f = 7;
        a0 = 1.1;
        phi0 = 0.92*a/a0*sin(pi/2*f/f0);
        theta=60e-6;
        p0 = (1.25+besselj(0,2*phi0))/(1.25+1)*2;
        p1 = 2*besselj(1,2*phi0)*theta;
        p2 = 2*besselj(2,2*phi0);
        
        plot(axisA, a, abs(5*p2./p0), 'r--');    %FIXME
        plot(axisA, a, abs(4*p2), 'g--');    %FIXME

        yyaxis(axisA, 'right');
        plot(axisA, a, P0, 'b.-');
        plot(axisA, a, P0(1)/2*p0, 'b--');

        yyaxis(axisB, 'left');
        plot(axisB, a, P2, 'r.-');
        yyaxis(axisB, 'right');
        plot(axisB, a, P2Q,'b.-');

        yyaxis(axisC, 'left');
        plot(axisC, a, P1X, 'r.-');
        yyaxis(axisC, 'right');
        plot(axisC, a, P1Y, 'b.-');
        
    case 9894     %fa: Modulation frequency and amplitude sweep
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        cla(axisA);
        cla(axisB);

        %sls = .25;  % second lockin sensitivity
        %sls = 1e-3;
        responsivity_dc = 10*1.04;   %   V/mW
        responsivity_ac = 40*1.04;   %   V/mW

        ampl = logdata.waveform.ampl;                   % Amplitude Vpp, V
        freq = logdata.waveform.freq*1e-6;              % Frequency, Hz
        P0  = 1e3*logdata.voltmeter.v1/responsivity_dc; % DC Power, uW
        P2X = 1e3*logdata.lockin.X/responsivity_ac;     % 2nd harm Power X, uW
        P2Y = 1e3*logdata.lockin.Y/responsivity_ac;     % 2nd harm Power Y, uW
        P2  = 1e3*logdata.lockin.R/responsivity_ac;     % 2nd harm Power R, uW
        P2Q = logdata.lockin.Q;                         % 2nd harm Power Q, deg
        
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
        
        p2 = zeros(1, n0);
        p2(1:n_curr) = P2;
        p2(n_curr:end) = p2(1);
        P2 = util.mesh.combine(p2, shape);
        
        surf(axisA, F, A, P0);
        surf(axisB, F, A, P2./P0);  %FIXME try contourf instead of surf
        
    case 120 %x: Kerr 1D scan
        axis = graphics.axes;
        yyaxis(axis, 'left'); cla(axis); 
        yyaxis(axis, 'right'); cla(axis);

        sls = .26;  % second lockin sensitivity
        splitter = .673;
        
        %x = logdata.X.position;                         % 
        y = logdata.Y.position;                         % 
        v0  = 1e3*logdata.voltmeter.v1;                 % DC Voltage, mV
        V1X = 1e3*logdata.lockin.X;                     % 1st harm Power X, uW
        V1Y = 1e3*logdata.lockin.Y;                     % 1st harm Power Y, uW
        V2X  = 1e3*logdata.lockin.AUX1*sls;                 % 2nd harm Power R, uW
        V2Y  = 1e3*logdata.lockin.AUX2*sls;                 % 2nd harm Power R, uW
        V2   = sqrt(V2X.^2+V2Y.^2);
        kerr = util.kerr(V1X, V2);
        
        n = numel(kerr);
        k = logdata.sweep.rate-logdata.sweep.pause;
        k = k(1);   %FIXME
        m = fix(n/k);
        if m*k ~= n
            disp(n)
            disp(m)
            disp(k)
            error("!")
        end
        KERR = mean(reshape(kerr, [k, m]),1);
        KERRstd = std(reshape(kerr, [k, m]),0,1);
        V0 = mean(reshape(v0, [k, m]),1);
        Y = mean(reshape(y, [k, m]),1);
        
        yyaxis(axis, 'left');
        plot(axis, Y, KERR, 'r.-');
        yyaxis(axis, 'right');
        plot(axis, Y, V0, 'b.-');
        yyaxis(axis, 'left');
        
        
        
        
    case 14520 %xy: Kerr 2D scan
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        cla(axisA);
        cla(axisB);

        responsivity_dc = 10*1.04;   %   V/mW
        responsivity_ac = 40*1.04;   %   V/mW
        sls = .26;  % second lockin sensitivity
        splitter = .673;

        x = logdata.X.position;                         % 
        y = logdata.Y.position;                         % 
        P0  = 1e3*logdata.voltmeter.v1/responsivity_dc; % DC Power, uW
        V1X = 1e3*logdata.lockin.X;                     % 1st harm Power X, uW
        V1Y = 1e3*logdata.lockin.Y;                     % 1st harm Power Y, uW
        V2X  = 1e3*logdata.lockin.AUX1*sls;                 % 2nd harm Power R, uW
        V2Y  = 1e3*logdata.lockin.AUX2*sls;                 % 2nd harm Power R, uW
        V2   = sqrt(V2X.^2+V2Y.^2);
        KERR = util.kerr(V1X, V2);
        
        shape = logdata.sweep.shape;
        x = 1e3*logdata.sweep.range(1,:);
        y = 1e3*logdata.sweep.range(2,:);
        X = util.mesh.combine(x, shape);
        Y = util.mesh.combine(y, shape);
        n0 = length(logdata.sweep.range);
        n_curr = length(P0);
        
        p0 = zeros(1, n0);
        p0(1:n_curr) = P0;
        p0(n_curr:end) = p0(1);
        P0 = util.mesh.combine(p0, shape);
        
        kerr = zeros(1, n0);
        kerr(1:n_curr) = KERR;
        kerr(n_curr:end) = kerr(1);
        KERR = util.mesh.combine(kerr, shape);
        
        surf(axisA, X, Y, P0, 'EdgeAlpha', .2);
        surf(axisB, X, Y, KERR, 'EdgeAlpha', .2);  %contourf vs surf?
        
    case 105    % i : Laser intensity sweep
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        axisC = graphics.axes(3);
        cla(axisA); yyaxis(axisA, 'left'); cla(axisA);
        cla(axisB); yyaxis(axisB, 'left'); cla(axisB);
        cla(axisC); yyaxis(axisC, 'left'); cla(axisC);

        sls = .1;  % second lockin sensitivity

        I   = logdata.diode.current;    % Laser curr, mA
        V0  = 1e3*logdata.voltmeter.v1;     % DC Volt, mV
        V1X = 1e6*logdata.lockin.X;         % 1st harm Volt X, uV
        V1Y = 1e6*logdata.lockin.Y;         % 1st harm Volt Y, uV
        V2X = sls*1e3*logdata.lockin.AUX1;  % 2nd harm Volt X, mV
        V2Y = sls*1e3*logdata.lockin.AUX2;  % 2nd harm Volt Y, mV

        c = besselj(2,1.841)/besselj(1,1.841);
        V2 = sqrt(V2X.^2+V2Y.^2);
        kerr = .5*atan(c*(V1X*1e-3)./V2)*1e6;

        yyaxis(axisA, 'left');
        plot(axisA, I, kerr, 'r.-');
        yyaxis(axisA, 'right');
        plot(axisA, I, V0, 'b.-');

        yyaxis(axisB, 'left');
        plot(axisB, I, V1X, 'r');
        yyaxis(axisB, 'right');
        plot(axisB, I, V1Y, 'b');

        yyaxis(axisC, 'left');
        plot(axisC, I, V2X, 'r.-');
        yyaxis(axisC, 'right');
        plot(axisC, I, V2Y, 'b.-');


    case 121    %y: Hysteresis test (mag field sweep)
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        axisC = graphics.axes(3);
        for ax = graphics.axes
            cla(ax); yyaxis(ax, 'left'); cla(ax);
        end

        sls = .26;      % second lockin sensitivity, V

        I   = 1e3*logdata.magnet.I;         % Magnet curr, mA
        V0  = 1e3*logdata.voltmeter.v1;     % DC Volt, mV
        V1X = 1e6*logdata.lockin.X;         % 1st harm Volt X, uV
        V1Y = 1e6*logdata.lockin.Y;         % 1st harm Volt Y, uV
        V2X = sls*1e3*logdata.lockin.AUX1;  % 2nd harm Volt X, mV
        V2Y = sls*1e3*logdata.lockin.AUX2;  % 2nd harm Volt Y, mV

        c = besselj(2,1.841)/besselj(1,1.841);
        V2 = sqrt(V2X.^2+V2Y.^2);
        kerr = .5*atan(c*(V1X*1e-3)./V2)*1e6;
        
        n = numel(kerr);
        k = logdata.sweep.rate-logdata.sweep.pause;
        k = k(1);
        m = fix(n/k);
        KERR = mean(reshape(kerr, [k, m]),1);
        KERRstd = std(reshape(kerr, [k, m]),0,1);
        CURR = mean(reshape(I, [k, m]),1);

        yyaxis(axisA, 'left');
%       plot(axisA, CURR, KERR, 'r.-');
        errorbar(axisA, CURR, KERR, KERRstd, 'r.-', 'MarkerSize', 5);
        yyaxis(axisA, 'right');
        plot(axisA, I, V0, 'b.-');

        yyaxis(axisB, 'left');
        plot(axisB, I, V1X, 'r');
        yyaxis(axisB, 'right');
        plot(axisB, I, V1Y, 'b');

        yyaxis(axisC, 'left');
        plot(axisC, I, V2X, 'r');
        yyaxis(axisC, 'right');
        plot(axisC, I, V2Y, 'b');


    case 112 %p: power optical
        axis = graphics.axes;
        cla(axis);

        i = logdata.diode.current;
        p = logdata.powermeter.power;
        v = logdata.diode.voltage;

        yyaxis(axis, 'left');
        plot(axis, i, 1e3*p, '.r');
        yyaxis(axis, 'right');
        plot(axis, i, v, '-b');

    case 100    % d : dc optical power sweep (Keithley 2182A)
        axis = graphics.axes;
        yyaxis(axis, 'left');
        cla(axis);
        yyaxis(axis, 'right');
        cla(axis);

        i = logdata.diode.current;
        dc = abs(logdata.voltmeter.v1);

        % New Focus 1601, 830 nm
        %sensitivity = 4.7;   % V/mW
        % New Focus 1801, 830 nm
        sensitivity = .47;   % V/mW

        % Thorlabs PDA100A2, 50 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e5*0.63;   % V/mW

        % Thorlabs PDA100A2, 30 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e4*0.63;   % V/mW

        % Thorlabs PDA100A2, 10 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e3*0.63;   % V/mW

        % Thorlabs PDA100A2, 0 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*1.51*1e3*0.63;   % V/mW

        yyaxis(axis, 'left');
        plot(axis, i, 1e3*dc, 'k.-');
        yyaxis(axis, 'right');
        plot(axis, i, 1e3*dc/sensitivity, 'k', 'LineStyle','none');

    case {119, 'w'}
        axis = graphics.axes;
        cla(axis);

        w = logdata.powermeter.wavelength;
        p = logdata.powermeter.power;

        plot(axis, w, 1e3*p, '.r');

    case 104    % h : Hall effect
        axisHallTimeA = graphics.axes(1);
        axisHallTimeB = graphics.axes(2);
        axisHallTempA = graphics.axes(3);
        axisHallTempB = graphics.axes(4);
        axisTempTime = graphics.axes(5);
        axisMagnTime = graphics.axes(6);
        for ax = graphics.axes
            cla(ax); yyaxis(ax, 'left'); cla(ax);
        end

        t = logdata.timer.time/60;      % Time, min
        TA = logdata.tempcont.A;        % Sample temperature, K
        TB = logdata.tempcont.B;        % Magnet temperature, K
        VAX = 1e3*logdata.lockinA.X;    % Lockin-A Voltage X, mV
        VAY = 1e3*logdata.lockinA.Y;    % Lockin-A Voltage Y, mV
        VBX = 1e3*logdata.lockinB.X;    % Lockin-B Voltage X, mV
        VBY = 1e3*logdata.lockinB.Y;    % Lockin-B Voltage Y, mV
        MagI = 1e3*logdata.magnet.I;    % Magnet Current, mA
        MagV = logdata.magnet.V;        % Magnet Voltage, V

        yyaxis(axisHallTimeA, 'left');
        plot(axisHallTimeA, t, VAX, 'Color', 'r');
        yyaxis(axisHallTimeA, 'right');
        plot(axisHallTimeA, t, VAY, 'Color', 'b');

        yyaxis(axisHallTimeB, 'left');
        plot(axisHallTimeB, t, VBX, 'Color', 'r');
        yyaxis(axisHallTimeB, 'right');
        plot(axisHallTimeB, t, VBY, 'Color', 'b');

        yyaxis(axisHallTempA, 'left');
        plot(axisHallTempA, TA, VAX, 'Color', 'r');
        yyaxis(axisHallTempA, 'right');
        plot(axisHallTempA, TA, VAY, 'Color', 'b');

        yyaxis(axisHallTempB, 'left');
        plot(axisHallTempB, TA, VBX, 'Color', 'r');
        yyaxis(axisHallTempA, 'right');
        plot(axisHallTempB, TA, VBY, 'Color', 'b');

        yyaxis(axisTempTime, 'left');
        plot(axisTempTime, t, TA, 'Color', 'r');
        yyaxis(axisTempTime, 'right');
        plot(axisTempTime, t, TB, 'Color', 'b');

        yyaxis(axisMagnTime, 'left');
        plot(axisMagnTime, t, MagI, 'Color', 'r');
        yyaxis(axisMagnTime, 'right');
        plot(axisMagnTime, t, MagV, 'Color', 'b');

    case 11960  % hs : Hall sensor
        axis = graphics.axes;
        cla(axis);

        curr = 1e3*logdata.magnet.I;

        volt = logdata.voltmeter.v1;
        sensitivity = 1e-3*3.125;   %V/G
        field = (volt-volt(1))/sensitivity;

        plot(axis, curr, field, '.-r');

    otherwise
        disp("Unknown seed.")
end
