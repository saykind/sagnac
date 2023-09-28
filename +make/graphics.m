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

%% Detector responsitivity
%Proper modulation parameters
f0 = 4.84;  % MHz
a0 = 0.54;  % Vpp
detector = '1811';
switch detector
    case '1811' % 1550 nm
        resp_dc = 10*1.04;      %   V/mW, should be 10.4 V/mW
        resp_ac = 40*1.04;      %   V/mW, should be 40.16 V/mW
        resp_ac = 100;
        a0 = 1.1;              %   Vpp
    case '1801' % 830 nm
        resp_dc = 1.65*1.04;    %   V/mW, should be 4.7 V/mW
        resp_ac = 20.5*1.04;    %   V/mW, should be 18.8 V/mW
    case '1601' % 830 nm
        resp_dc = 10*1.04;      %   V/mW, should be 4.7 V/mW
        resp_ac = .5*1.04;      %   V/mW
    case 'PDA'  % 830 nm
        resp_dc = 1e-3*1.51*1e3*0.63;  %V/mW
end


%% Given graphics, draw a plot    
switch key
    case 84     %T: time vs Temperature
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        cla(axisA); cla(axisB);

        t = logdata.timer.time/60;
        d = datetime(logdata.timer.datetime);
        d = dateshift(d,'start','minute') + seconds(round(second(d),0));
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
        %xtickformat(axisB, 'hh:mm:ss');

    case 12412  %tk: time vs Kerr
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        axisC = graphics.axes(3);
        for ax = graphics.axes
            yyaxis(ax, 'right'); cla(ax); 
            yyaxis(ax, 'left'); cla(ax);
        end

        sls = .25;  % second lockin sensitivity

        t = logdata.timer.time/60;          % Time, min
        dc = 1e3*logdata.voltmeter.v1;      % DC voltage, mV
        V1X = 1e6*logdata.lockin.X;         % 1st harm Voltage X, uV
        V1Y = 1e6*logdata.lockin.Y;         % 1st harm Voltage Y, uV
        V2X = sls*1e3*logdata.lockin.AUX1;  % 2nd harm Voltage X, mV
        V2Y = sls*1e3*logdata.lockin.AUX2;  % 2nd harm Voltage Y, mV

        V2 = sqrt(V2X.^2+V2Y.^2);
        c = besselj(2,.5/1.1*1.841)/besselj(1,.5/1.1*1.841);
        kerr = .5*atan(c*V1X*1e-3./V2)*1e6;
        %kerr = util.kerr(V1X*1e-3, V2);

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


    case 11600 %td: dc voltage (time only)
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        axisC = graphics.axes(3);
        for ax = graphics.axes
            yyaxis(ax, 'right'); cla(ax); 
            yyaxis(ax, 'left'); cla(ax);
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
        %ylim(axisC, [5.6,6]);
        %ylim(axisC, [-inf,inf]);
        yyaxis(axisC, 'right');
        plot(axisC, t, P2./P0, 'Color', 'b');
        %ylim(axisC, [1.1,1.15]);
        %ylim(axisC, [-inf,inf]);
        
    case 9900 %dc: dc voltage (LARGE text)
        ax = graphics.axes(1);
        cla(axis); 
        
        dc = 1e3*logdata.voltmeter.v1;  % DC voltage, mV
        
        t1 = sprintf("DC = %.2f mV.", dc(end));
        t2 = sprintf("MAX = %.2f mV.", max(dc));
        text(ax, .0, .65, t1, 'FontSize', 120);
        text(ax, .0, .35, t2, 'FontSize', 120, 'Color', 'red');
        
        

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
        
        
case 1290848    %kth: Kerr effect, transport, hall
        [axisA, axisB, axisC, ...
            axisTtA, axisTtB, ...
            axisTA, axisTB, axisTC, ...
            axisTBA, ...
            axisPa, axisPb, ...
            axisHall, ...
            axisTr ...
            ] = util.unpack(graphics.axes);
        for ax = graphics.axes
            yyaxis(ax, 'right'); cla(ax); 
            yyaxis(ax, 'left'); cla(ax);
        end

        sls = .25;  % second lockin sensitivity
        h0 = 2.5112;
        h_sens = 1e-3*3.125;   %V/G
        curr = 10*1e-9;    % Amps

        t = logdata.timer.time/60;      % Time, min
        TA = logdata.tempcont.A;         % Temp, K
        TB = logdata.tempcont.B;         % Temp, K
        T2A = logdata.temp.A;           % Temp, K
        T2B = logdata.temp.B;           % Temp, K
        dc = 1e3*logdata.voltmeter.v1;  % DC voltage, mV
        V1X = 1e6*logdata.lockin.X;     % 1st harm Voltage X, uV
        V1Y = 1e6*logdata.lockin.Y;     % 1st harm Voltage Y, uV
        V2X = sls*1e3*logdata.lockin.AUX1;  % 2nd harm Voltage X, mV
        V2Y = sls*1e3*logdata.lockin.AUX2;  % 2nd harm Voltage Y, mV
        h = (logdata.voltmeter.v2-h0)/h_sens;   % Mag field, Oe
        h = logdata.voltmeter.v2;   % Mag field, Oe
        r = logdata.lockinA.X/curr;         % Resistnace, Ohms

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
        
        yyaxis(axisTtB, 'left');
        plot(axisTtB, t, T2A, 'Color', 'r');
        yyaxis(axisTtB, 'right');
        plot(axisTtB, t, T2B, 'Color', 'b');

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

        % Hall sesnor
        plot(axisHall, TA, h, 'Color', 'r');
        
        % Transport
        plot(axisTr, TA, r, 'Color', 'r');

        
    %% Modulation sweeps
    case 102    %f: Mod freq sweep
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        for ax = graphics.axes
            yyaxis(ax, 'right'); cla(ax); 
            yyaxis(ax, 'left'); cla(ax);
        end

        %sls = .25;  % second lockin sensitivity

        f   = logdata.waveform.freq*1e-6;               % Freq, MHz
        P0  = 1e3*abs(logdata.voltmeter.v1)/resp_dc;    % DC Power, uW
        PX = 1e3*logdata.lockin.X/resp_ac;             % 2nd harm Power X, uW
        PY = 1e3*logdata.lockin.Y/resp_ac;             % 2nd harm Power Y, uW
        PR  = 1e3*logdata.lockin.R/resp_ac;             % 2nd harm Power R, uW
        PQ = logdata.lockin.Q;                         % 2nd harm Power Q, deg

        yyaxis(axisA, 'left');
        plot(axisA, f, PR./P0, 'r.-');
        yyaxis(axisA, 'right');
        plot(axisA, f, P0, 'b.-');
        
        yyaxis(axisB, 'left');
        plot(axisB, f, PR, 'r');
        yyaxis(axisB, 'right');
        plot(axisB, f, PQ,'b');
        
        % Theoretical values
        a  = a0;
        phi = 2*0.92*a/a0*sin(pi/2*f/f0);
        theta = 1e-3;
        p0 = 1+besselj(0,phi);
        %p = 2*besselj(1,phi)*theta;
        p = 2*besselj(2,phi);
        ph = PQ(1) - 180*(f-f(1))/f0;
        A = P0(1)/p0(1);
        
        yyaxis(axisA, 'left');
        plot(axisA, f, abs(p)./p0, 'r--');
        yyaxis(axisA, 'right');
        plot(axisA, f, A*p0, 'b--');

        yyaxis(axisB, 'left');
        plot(axisB, f, A*abs(p), 'r--');
        yyaxis(axisB, 'right');
        plot(axisB, f, ph,'b--');


    case 97     %a: Modulation amplitude sweep
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        for ax = graphics.axes
            yyaxis(ax, 'right'); cla(ax); 
            yyaxis(ax, 'left'); cla(ax);
        end

        %sls = .26;  % second lockin sensitivity
        %splitter = .673;
        splitter = 1;

        a  = logdata.waveform.ampl;                    % Amplitude Vpp, V
        P0 = 1e3*logdata.voltmeter.v1/resp_dc;         % DC Power, uW
        P0 = abs(P0);
        PX = 1e3*logdata.lockin.X/splitter/resp_ac;    % AC Power X, uW
        PY = 1e3*logdata.lockin.Y/splitter/resp_ac;    % AC Power Y, uW
        PR = 1e3*logdata.lockin.R/splitter/resp_ac;    % AC Power R, uW
        PQ = logdata.lockin.Q;                         % Ac Power Q, deg

        yyaxis(axisA, 'left');
        plot(axisA, a, PR./P0, 'r.-');
        yyaxis(axisA, 'right');
        plot(axisA, a, P0, 'b.-');
        
        yyaxis(axisB, 'left');
        plot(axisB, a, PR, 'r.-');
        yyaxis(axisB, 'right');
        plot(axisB, a, PQ,'b.-');
        
        % Theoretical values
        f = f0;
        phi = 2*0.92*a/a0*sin(pi/2*f/f0);
        theta = 1.085;
        p0 = 1+cos(2*theta)*besselj(0,phi);
        %p = 2*besselj(1,phi)*sin(theta);
        p = 2*besselj(2,phi)*cos(theta);
        A  = P0(1)/p0(1);
        
        yyaxis(axisA, 'left');
        plot(axisA, a, abs(p)./p0, 'r--');
        yyaxis(axisA, 'right');
        plot(axisA, a, A*p0, 'b--');
        
        yyaxis(axisB, 'left');
        plot(axisB, a, A*abs(p), 'r--');

        
        
    case 9894     %fa: Modulation frequency and amplitude sweep
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
        
        sls = 1e3*.25;  % second lockin sensitivity
        P2X = sls*logdata.lockin.AUX1/resp_ac;      % AC Power X, uW
        P2Y = sls*logdata.lockin.AUX2/resp_ac;      % AC Power X, uW
        P2 = sqrt(P2X.^2+P2Y.^2);
        
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
        %try contourf instead of surf?
        
    
    %% Position sweep    
    case 120 %x: Kerr 1D scan
        ax = graphics.axes;
        yyaxis(ax, 'left'); cla(ax); 
        yyaxis(ax, 'right'); cla(ax);

        sls = .26;  % second lockin sensitivity
        splitter = .673;
        resp_dc = 10*1.04;   %   V/mW
        
        %x = logdata.X.position;                         % 
        y = logdata.X.position;                         % 
        v0  = 1e3*logdata.voltmeter.v1/resp_dc; % DC Voltage, mV
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
        
        %Knife edge
%         if numel(Y) > fix(numel(logdata.sweep.range)*0.95)
%             Y = (Y - Y(1))*1e3;
%             V0 = V0-(V0(end)+.5*(V0(1)-V0(end)));
%             xlabel(ax, 'Position, \mum');
%             eqn = 'a*erf(sqrt(2)*(x-b)/c)';
%             [f, ~] = fit(Y.', V0.', eqn, 'Start', [30, 0, 5]);
%         
%             Yf = linspace(min(Y), max(Y), 1e3);
%             Zf = f.a*erf(sqrt(2)*(Yf-f.b)/f.c); 
% 
%             cf = confint(f);
%             disp(f.a);
%             disp(f.b);
%             fprintf("Radius = %.2f um (%.2f, %.2f)\n", f.c, cf(:,3)');
%             
%             plot(ax, Yf, Zf, 'k--');
%         end
        
        Y = Y - 13;
        yyaxis(ax, 'left');
        %plot(ax, Y, KERR, 'r.-');
        yyaxis(ax, 'right');
        plot(ax, Y, V0, 'b.-');
        yyaxis(ax, 'left');
        
        
    case 14520 %xy: Kerr 2D scan
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        cla(axisA);
        cla(axisB);

        resp_dc = 10*1.04;   %   V/mW
        resp_ac = 40*1.04;   %   V/mW
        sls = .26;  % second lockin sensitivity
        splitter = .673;

        p0  = 1e3*logdata.voltmeter.v1/resp_dc; % DC Power, uW
        V1X = 1e3*logdata.lockin.X;                     % 1st harm Power X, uW
        V1Y = 1e3*logdata.lockin.Y;                     % 1st harm Power Y, uW
        V2X  = 1e3*logdata.lockin.AUX1*sls;             % 2nd harm Power R, uW
        V2Y  = 1e3*logdata.lockin.AUX2*sls;             % 2nd harm Power R, uW
        V2   = sqrt(V2X.^2+V2Y.^2);
        kerr = util.kerr(V1X, V2);
        
        n = numel(kerr);
        k = logdata.sweep.rate-logdata.sweep.pause;
        k = k(1);                                       %FIXME
        m = fix(n/k);
        KERR = mean(reshape(kerr, [k, m]),1);
        P0 = mean(reshape(p0, [k, m]),1);
        
        shape = logdata.sweep.shape;
        x = 1e3*logdata.sweep.range(1,:);
        y = 1e3*logdata.sweep.range(2,:);
        if isfield(logdata.sweep, 'origin')
            x = x - 1e3*logdata.sweep.origin(1);
            y = y - 1e3*logdata.sweep.origin(2);
        end
        X = util.mesh.combine(x, shape);
        Y = util.mesh.combine(y, shape);
        n0 = length(logdata.sweep.range);
        n_curr = length(P0);
        
        p0 = zeros(1, n0);
        p0(1:n_curr) = P0;
        if n_curr ~= n0, p0(n_curr:end) = p0(1); end
        P0 = util.mesh.combine(p0, shape);
        
        kerr = zeros(1, n0);
        kerr(1:n_curr) = KERR;
        if n_curr ~= n0, kerr(n_curr:end) = kerr(1); end
        KERR = util.mesh.combine(kerr, shape);
        
        axis(axisA, 'tight');
        axis(axisB, 'tight');
        surf(axisA, X, Y, P0, 'EdgeAlpha', .2);
        surf(axisB, X, Y, KERR, 'EdgeAlpha', .2);
        
        if n_curr == n0
            figure('Units', 'centimeters', 'Position',  [0, 0, 16, 16]);
            imagesc([min(X) max(X)], [min(Y) max(Y)], flip(P0,1));
            axis equal;
            axis off;
            
            figure('Units', 'centimeters', 'Position',  [0, 0, 16, 16]);
            imagesc([min(X) max(X)], [min(Y) max(Y)], flip(KERR,1));
            axis equal;
            axis off;
            colormap(summer);
        end
        
    case 105    %i: Laser intensity sweep
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
        v0  = 1e3*logdata.voltmeter.v1;     % DC Volt, mV
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
        V0 = mean(reshape(v0, [k, m]),1);
        
        % Sample at the top of the magnet
        % 250 G/A
        CURR = CURR/4;

        yyaxis(axisA, 'left');
%       plot(axisA, CURR, KERR, 'r.-');
        errorbar(axisA, CURR, KERR, KERRstd, 'r.-', 'MarkerSize', 5);
        yyaxis(axisA, 'right');
        %plot(axisA, CURR, V0, 'b.-');
        xlabel(axisA, 'Magnetic Field, Oe');

        yyaxis(axisB, 'left');
        plot(axisB, I, V1X, 'r');
        yyaxis(axisB, 'right');
        plot(axisB, I, V1Y, 'b');

        yyaxis(axisC, 'left');
        plot(axisC, I, V2X, 'r');
        yyaxis(axisC, 'right');
        plot(axisC, I, V2Y, 'b');


    case 112 %p: power optical
        ax = graphics.axes;
        cla(ax);

        i = logdata.diode.current;
        p = logdata.powermeter.power;
        v = logdata.diode.voltage;

        yyaxis(ax, 'left');
        plot(ax, i, 1e3*p, '.r');
        yyaxis(ax, 'right');
        plot(ax, i, v, '-b');

    case 100    %d: dc optical power sweep (Keithley 2182A)
        ax = graphics.axes;
        yyaxis(ax, 'left');
        cla(ax);
        yyaxis(ax, 'right');
        cla(ax);

        i = logdata.diode.current;
        dc = abs(logdata.voltmeter.v1);

        % New Focus 1601, 830 nm
        %sensitivity = 4.7;   % V/mW
        % New Focus 1801, 830 nm
        %sensitivity = .47;   % V/mW

        % Thorlabs PDA100A2, 50 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e5*0.63;   % V/mW

        % Thorlabs PDA100A2, 30 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e4*0.63;   % V/mW

        % Thorlabs PDA100A2, 10 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e3*0.63;   % V/mW

        % Thorlabs PDA100A2, 0 dB gain, Hi-Z, 830 nm
        sensitivity = 1e-3*1.51*1e3*0.63;   % V/mW

        yyaxis(ax, 'left');
        plot(ax, i, 1e3*dc, 'k.-');
        yyaxis(ax, 'right');
        plot(ax, i, 1e3*dc/sensitivity, 'k', 'LineStyle','none');
        
        
    case 477128 %LIV:  Laser IV characteristic
        ax = graphics.axes;
        yyaxis(ax, 'left');
        cla(ax);
        yyaxis(ax, 'right');
        cla(ax);

        curr = logdata.diode.current;
        volt = logdata.diode.voltage;
        dc = abs(logdata.voltmeter.v1);
        
        if isfield(logdata, 'sweep') && false
            n = numel(curr);
            k = logdata.sweep.rate-logdata.sweep.pause;
            m = fix(n/k);
            CURR = mean(reshape(curr, [k, m]),1);
            VOLT = mean(reshape(volt, [k, m]),1);
            DC = mean(reshape(dc, [k, m]),1);
        else
            CURR = curr;
            VOLT = volt;
            DC = dc;
        end

        % New Focus 1601, 830 nm
        %sensitivity = 4.7;   % V/mW
        % New Focus 1801, 830 nm
        %sensitivity = .47;   % V/mW

        % Thorlabs PDA100A2, 50 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e5*0.63;   % V/mW

        % Thorlabs PDA100A2, 30 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e4*0.63;   % V/mW

        % Thorlabs PDA100A2, 10 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e3*0.63;   % V/mW

        % Thorlabs PDA100A2, 0 dB gain, Hi-Z, 830 nm
        sensitivity = 1e-3*1.51*1e3*0.63;   % V/mW

        yyaxis(ax, 'left');
        plot(ax, CURR, DC/sensitivity, 'r.-');
        yyaxis(ax, 'right');
        plot(ax, CURR, VOLT, 'b.-');
        
        
    case 119 %w: wavelength
        ax = graphics.axes;
        cla(ax);

        w = logdata.powermeter.wavelength;
        p = logdata.powermeter.power;

        plot(ax, w, 1e3*p, '.r');
        
        
    case 11948    %tg: Two transport lockins & gate voltage controller
        ax = graphics.axes(1);
        cla(ax); yyaxis(ax, 'left'); cla(ax);

        v = logdata.source.V;
        vx = logdata.lockinB.X;
        vy = logdata.lockinB.Y;
        r = logdata.lockinB.X./logdata.lockinA.amplitude*10.08*1e6;
        r = logdata.lockinB.X./logdata.lockinA.R;
        curr = logdata.source.I;
        
        yyaxis(ax, 'left');
        plot(ax, v, 1e-3*abs(r), '.-r');
        yyaxis(ax, 'right');
        plot(ax, v, 1e9*curr, '.-b');
        
        

    case 104    %h: Hall effect
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

    case 11960  %hs: Hall sensor
        ax = graphics.axes;
        cla(ax);

        curr = 1e3*logdata.magnet.I;

        volt = logdata.voltmeter.v2;
        sensitivity = 1e-3*3.125;   %V/G
        field = (volt-volt(1))/sensitivity;

        plot(ax, curr, field, '.-r');
        
    case 11832  %tf: Transport freq sweep
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        yyaxis(axisA, 'left');
        cla(axisA); 
        yyaxis(axisA, 'right');
        cla(axisA); 
        yyaxis(axisB, 'left');
        cla(axisB); 
        yyaxis(axisB, 'right');
        cla(axisB); 

        f = 1e-3*logdata.lockin.f;
        X = 1e3*logdata.lockin.X;
        Y = 1e3*logdata.lockin.Y;
        R = 1e3*logdata.lockin.R;
        Q = logdata.lockin.Q;

        yyaxis(axisA, 'left');
        plot(axisA, f, X, 'r.-');
        yyaxis(axisA, 'right');
        plot(axisA, f, Y, 'b.-');
        
        yyaxis(axisB, 'left');
        plot(axisB, f, R, 'r.-');
        yyaxis(axisB, 'right');
        plot(axisB, f, Q, 'b.-');


    otherwise
        disp("Unknown seed.")
end
