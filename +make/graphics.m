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

%% Parameters. Detector responsitivity
sls = .1; % second harm lockin sensitivity
%Proper modulation parameters
f0 = 4.8425;  % MHz
a0 = 0.55;  % Vpp
detector = '1801';
switch detector
    case '1811' % 1550 nm
        resp_dc = 10*1.04;      %   V/mW, should be 10.4 V/mW
        resp_ac = 40*1.04;      %   V/mW, should be 40.16 V/mW
        a0 = 1.1;              %   Vpp
    case '1801' % 830 nm
        resp_dc = 4.7;          %   V/mW, should be 4.7 V/mW
        resp_ac = 5.15;         %   V/mW, should be 18.8 V/mW
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

        t = logdata.timer.time/60;      % Time, min
        TA = logdata.tempcont.A;         % Temp, K
        TB = logdata.tempcont.B;         % Temp, K
        dc = 1e3*logdata.voltmeter.v1;  % DC voltage, mV
        V1X = 1e6*logdata.lockin.X;     % 1st harm Voltage X, uV
        V1Y = 1e6*logdata.lockin.Y;     % 1st harm Voltage Y, uV
        V2X = sls*1e3*logdata.lockin.AUX1;  % 2nd harm Voltage X, mV
        V2Y = sls*1e3*logdata.lockin.AUX2;  % 2nd harm Voltage Y, mV

        V2 = sqrt(V2X.^2+V2Y.^2);
        kerr = util.math.kerr(V1X*1e-3, V2);
        

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
        %plot(axisTC, TA, V2, 'k-');
        yyaxis(axisTC, 'right');
        plot(axisTC, TA, V2Y, 'Color', 'b');
        
        %xlim(axisTA, [-inf, 120]);
        %xlim(axisTB, [-inf, 120]);
        %xlim(axisTC, [-inf, 120]);

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
            axisTrt, ...
            axisTr ...
            ] = util.unpack(graphics.axes);
        for ax = graphics.axes
            yyaxis(ax, 'right'); cla(ax); 
            yyaxis(ax, 'left'); cla(ax);
        end

        sls = .25;      % second lockin sensitivity
        curr = 1e-3;    % Amps
        gain = 1;

        t = logdata.timer.time/60;      % Time, min
        TA = logdata.tempcont.A;         % Temp, K
        TB = logdata.tempcont.B;         % Temp, K
        dc = 1e3*logdata.voltmeter.v1;  % DC voltage, mV
        V1X = 1e6*logdata.lockin.X;     % 1st harm Voltage X, uV
        V1Y = 1e6*logdata.lockin.Y;     % 1st harm Voltage Y, uV
        V2X = sls*1e3*logdata.lockin.AUX1;  % 2nd harm Voltage X, mV
        V2Y = sls*1e3*logdata.lockin.AUX2;  % 2nd harm Voltage Y, mV
        vX = 1e6*logdata.lockinA.X;             % Transport, uV
        r = logdata.lockinA.X/curr/gain*1e3;         % Resistnace, mOhms

        V2 = sqrt(V2X.^2+V2Y.^2);
        kerr = util.math.kerr(V1X*1e-3, V2);

        % Kerr vs Time
        yyaxis(axisA, 'left');
        plot(axisA, t, kerr, 'Color', 'r');
        yyaxis(axisA, 'right');
        plot(axisA, t, dc, 'Color', 'b');
        yyaxis(axisA, 'left');

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
        plot(axisTC, TA, V2, 'r-');
        yyaxis(axisTC, 'right');
        plot(axisTC, TA, dc, 'Color', 'b');
        

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

        % Transport vs time
        plot(axisTrt, t, vX, 'Color', 'r');
        
        % Transport
        plot(axisTr, TA, r, 'Color', 'r');
        
    case 1228788    %ktc: kerr, transport, capacitance
        [axisA, axisB, axisC, ...
            axisTtA, axisTtB, ...
            axisTA, axisTB, axisTC, ...
            axisTBA, ...
            axisPa, axisPb, ...
            axisCapacitance, axisStrainCell, ...
            axisTrA, axisTrB ...
            ] = util.unpack(graphics.axes);
        for ax = graphics.axes
            yyaxis(ax, 'right'); cla(ax); 
            yyaxis(ax, 'left'); cla(ax);
        end

        sls = .25;  % second lockin sensitivity
        curr = .1;    % Amps
        L_gap = 50;                                     % um
        L_smp = 1500;                                   % um
        
        t = logdata.timer.time/60;          % Time, min
        TA = logdata.tempcont.A;            % Temp, K
        TB = logdata.tempcont.B;            % Temp, K
        dc = 1e3*logdata.voltmeter.v1;      % DC voltage, mV
        V1X = 1e6*logdata.lockin.X;         % 1st harm Voltage X, uV
        V1Y = 1e6*logdata.lockin.Y;         % 1st harm Voltage Y, uV
        V2X = sls*1e3*logdata.lockin.AUX1;  % 2nd harm Voltage X, mV
        V2Y = sls*1e3*logdata.lockin.AUX2;  % 2nd harm Voltage Y, mV
        r = logdata.lockinA.X/curr;         % Resistnace, Ohms
        rY = logdata.lockinA.Y/curr;        % Resistnace Y, Ohms
        C = logdata.bridge.C;               % Capacitance, pF
        C0 = mean(C);
        e  = -100*(L_gap/L_smp)*(C-C0)/C0;  % strain, %
        v = 1e3*logdata.lockinA.AUXV1;      % Output voltage, mV

        V2 = sqrt(V2X.^2+V2Y.^2);
        kerr = util.math.kerr(V1X*1e-3, V2);

        % Kerr vs Time
        yyaxis(axisA, 'left');
        plot(axisA, t, kerr, 'Color', 'r');
        yyaxis(axisA, 'right');
        plot(axisA, t, dc, 'Color', 'b');
        yyaxis(axisA, 'left');

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
        %xlim(axisTA, [50, inf]);

        yyaxis(axisTB, 'left');
        plot(axisTB, TA, V1X, 'Color', 'r');
        yyaxis(axisTB, 'right');
        plot(axisTB, TA, V1Y, 'Color', 'b');

        yyaxis(axisTC, 'left');
        plot(axisTC, TA, V2, 'r-');
        yyaxis(axisTC, 'right');
        plot(axisTC, TA, dc, 'Color', 'b');

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

        % Strain cell
        yyaxis(axisCapacitance, 'left');
        plot(axisCapacitance, t, C, 'Color', 'r');
        yyaxis(axisCapacitance, 'right');
        plot(axisCapacitance, t, e, 'Color', 'b');
        plot(axisStrainCell, t, v, 'Color', 'r')
        
        % Transport
        %[r, rY] = util.adjustPhase(r, rY, -.4+.008);
        yyaxis(axisTrA, 'left');
        plot(axisTrA, TA, r, 'Color', 'r');
        yyaxis(axisTrA, 'right');
        plot(axisTrA, TA, rY, 'Color', 'b');
        plot(axisTrB, v, r, 'Color', 'r');
        
        

    case 1278436    %ktg: Kerr effect, transport, gate
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

        sls = .25;                          % 2nd harm lockin sensitivity
        curr = 1e-3;                        % Transport current, Amps

        t = logdata.timer.time/60;          % Time, min
        v = logdata.source.V;               % Gate voltage, V
        i = 1e9*logdata.source.I;           % Gate leakadge current, nA
        tA = logdata.tempcont.A;            % Temp A, K
        tB = logdata.tempcont.B;            % Temp B, K
        dc = 1e3*logdata.voltmeter.v1;      % DC voltage, mV
        v1x = 1e6*logdata.lockin.X;         % 1st harm Voltage X, uV
        v1y = 1e6*logdata.lockin.Y;         % 1st harm Voltage Y, uV
        v2x = sls*1e3*logdata.lockin.AUX1;  % 2nd harm Voltage X, mV
        v2y = sls*1e3*logdata.lockin.AUX2;  % 2nd harm Voltage Y, mV
        vAx = 1e9*logdata.lockinA.X;        % Lockin A V_X, nA
        vBx = 1e6*logdata.lockinB.X;        % Lockin A V_X, mV

        v2 = sqrt(v2x.^2 + v2y.^2);
        kerr = util.math.kerr(v1x*1e-3, v2);
        
        % Average datapoints
        n = numel(kerr);
        k = logdata.sweep.rate-logdata.sweep.pause;
        k = k(1);   %FIXME
        m = fix(n/k);
        fprintf("kerr_mean = %.3f\n", mean(kerr));
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
        


        
    %% Modulation sweeps
    case 102    %f: Mod freq sweep
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        for ax = graphics.axes
            yyaxis(ax, 'right'); cla(ax); 
            yyaxis(ax, 'left'); cla(ax);
        end

        sls = .25;  % second lockin sensitivity
        sls = 1;
        splitter = .673;
        %splitter = 1;
        resp_dc = 4.7;
        resp_ac = 5;

        f   = logdata.waveform.freq*1e-6;               % Freq, MHz
        P0  = 1e3*abs(logdata.voltmeter.v1)/resp_dc;    % DC Power, uW
        PX = 1e3*logdata.lockin.X/splitter/resp_ac;     % AC Power X, uW
        PY = 1e3*logdata.lockin.Y/splitter/resp_ac;     % AC Power Y, uW
        PR  = 1e3*logdata.lockin.R/splitter/resp_ac;    % AC Power R, uW
        PQ = logdata.lockin.Q;                          % AC Power Q, deg
        % Calculate kerr
        P2X = sls*logdata.lockin.AUX1/resp_ac;      % AC Power X, uW
        P2Y = sls*logdata.lockin.AUX2/resp_ac;      % AC Power X, uW
        P2 = sqrt(P2X.^2+P2Y.^2);
        K  = util.math.kerr(PX, P2);

        yyaxis(axisA, 'left');
        plot(axisA, f, PR./P0, 'r.-');
        %plot(axisA, f, P2./P0, 'bx-');
        yyaxis(axisA, 'right');
        plot(axisA, f, P0, 'b.-');
        
        %legend(axisA, ["1\omega mag", "2\omega mag"]);
        
        yyaxis(axisB, 'left');
        plot(axisB, f, PX, 'r.-');
        yyaxis(axisB, 'right');
        plot(axisB, f, PY, 'b.-');
        
        % Theoretical values
        a  = a0;
        phi = 2*0.92*a/a0*sin(pi/2*f/f0);
        theta = 0;
        p0 = 1+besselj(0,phi);
        p = 2*besselj(1,phi)*theta;
        %p = 2*besselj(2,phi);
        ph = PQ(1) - 180*(f-f(1))/f0;
        A = P0(1)/p0(1);
        
        yyaxis(axisA, 'left');
        %plot(axisA, f, abs(p), 'r--');
        yyaxis(axisA, 'right');
        %plot(axisA, f, A*p0, 'b--');

        yyaxis(axisB, 'left');
        plot(axisB, f, A*p, 'r--');
        yyaxis(axisB, 'right');
        %plot(axisB, f, ph,'b--');


    case 97     %a: Modulation amplitude sweep
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        for ax = graphics.axes
            yyaxis(ax, 'right'); cla(ax); 
            yyaxis(ax, 'left'); cla(ax);
        end

        sls = .25;  % second lockin sensitivity
        splitter = .673;
        splitter = 1;
        resp_dc = 4.7;
        resp_ac = 5;


        a  = logdata.waveform.ampl;                    % Amplitude Vpp, V
        P0 = 1e3*logdata.voltmeter.v1/resp_dc;         % DC Power, uW
        P0 = abs(P0);
        PX = 1e3*logdata.lockin.X/splitter/resp_ac;    % AC Power X, uW
        PY = 1e3*logdata.lockin.Y/splitter/resp_ac;    % AC Power Y, uW
        PR = 1e3*logdata.lockin.R/splitter/resp_ac;    % AC Power R, uW
        PQ = logdata.lockin.Q;                         % Ac Power Q, deg
        
        P2X = sls*logdata.lockin.AUX1/splitter/resp_ac;      % AC Power X, uW
        P2Y = sls*logdata.lockin.AUX2/splitter/resp_ac;      % AC Power X, uW
        P2 = sqrt(P2X.^2+P2Y.^2);

        yyaxis(axisA, 'left');
        plot(axisA, a, PR./P0, 'r.-');
        plot(axisA, a, P2./P0, 'rx-');
        yyaxis(axisA, 'right');
        plot(axisA, a, P0, 'b.-');
        
        legend(axisA, ["1\omega mag", "2\omega mag"]);
        
        yyaxis(axisB, 'left');
        plot(axisB, a, PR, 'r.-');
        yyaxis(axisB, 'right');
        plot(axisB, a, PQ,'b.-');
        
        % Theoretical values
        f = f0;
        phi = 2*0.92*a/a0*sin(pi/2*f/f0);
        theta =0;
        p0 = 1+cos(2*theta)*besselj(0,phi);
        %p = 2*besselj(1,phi)*sin(theta);
        p = 2*besselj(2,phi)*cos(theta);
        A  = P0(1)/p0(1);
        
        yyaxis(axisA, 'left');
        %plot(axisA, a, abs(p)./p0, 'r--');
        yyaxis(axisA, 'right');
        %plot(axisA, a, A*p0, 'b--');
        
        yyaxis(axisB, 'left');
        %plot(axisB, a, A*abs(p), 'r--');

        
        
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
        %xlim(axisA, [4.4, 5.2]);
        %xlim(axisB, [4.4, 5.2]);
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
        kerr = util.math.kerr(V1X, V2);
        
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
        Y = Y - logdata.sweep.origin;
        Y = Y*1e3;  % convert mm to um
        
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
        
        yyaxis(ax, 'left');
        plot(ax, Y, KERR, 'r.-');
        yyaxis(ax, 'right');
        plot(ax, Y, V0, 'b.-');
        yyaxis(ax, 'left');
        
        
    case 14520 %xy: Kerr 2D scan
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        cla(axisA);
        cla(axisB);

        resp_dc = 4.7;   %   V/mW
        resp_ac = 5.15;   %   V/mW
        splitter = .673;

        p0  = 1e3*logdata.voltmeter.v1;                 % DC Power, uW
        V1X = 1e3*logdata.lockin.X;                     % 1st harm Power X, uW
        V1Y = 1e3*logdata.lockin.Y;                     % 1st harm Power Y, uW
        V2X  = 1e3*logdata.lockin.AUX1*sls;             % 2nd harm Power R, uW
        V2Y  = 1e3*logdata.lockin.AUX2*sls;             % 2nd harm Power R, uW
        V2   = sqrt(V2X.^2+V2Y.^2);
        kerr = util.math.kerr(V1X, V2);
        
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
        
        %P0 = log(P0);
        % Mask low power points
        P0_cutoff = 150;
        P0_maxlim = inf;
        n_cutoff = fix(n0/4);
        if n_curr > n_cutoff
            low_power_idx = P0 < P0_cutoff;
            if any(low_power_idx, 'all')
                kerr_max = max(KERR(~low_power_idx));
                kerr_min = min(KERR(~low_power_idx));
                kerr_bad = mean([kerr_max kerr_min]) + kerr_max-kerr_min;
                KERR(low_power_idx) = kerr_bad;
            end
        end
        
        axis(axisA, 'tight');
        axis(axisB, 'tight');
        surf(axisA, X, Y, P0, 'EdgeAlpha', .2);
        surf(axisB, X, Y, KERR, 'EdgeAlpha', .2);
        
        if n_curr > n_cutoff
            low_power_idx = P0 < P0_cutoff;
            if any(low_power_idx, 'all')
                caxis(axisA, [P0_cutoff P0_maxlim]); %Renamed to caxis in R2022a
                zlim(axisA, [P0_cutoff inf]);
                caxis(axisB, [kerr_min kerr_max]); %Renamed to caxis in R2022a
                zlim(axisB, [kerr_min kerr_max]);
            end
            if n_curr == n0
                fprintf("kerr_avg = %.1f urad.\n", mean(KERR(~low_power_idx)));
                fprintf("kerr_std = %.1f urad.\n", std(KERR(~low_power_idx)));
            end
        else
            caxis(axisA, [-inf inf]);  %Renamed to caxis in R2022a
            caxis(axisB, [-inf inf]); %Renamed to caxis in R2022a
        end
                
        
        %caxis(axisB, [-1 7]);
        %zlim(axisB, [-1 7]);
        
        
        if n_curr == n0
            %figure('Units', 'centimeters', 'Position',  [0, 0, 16, 16]);
            %imagesc([min(X) max(X)], [min(Y) max(Y)], flip(P0,1));
            %caxis([P0_cutoff inf]);
            %axis equal;
            %axis off;
            
            %figure('Units', 'centimeters', 'Position',  [0, 0, 16, 16]);
            %imagesc([min(X) max(X)], [min(Y) max(Y)], flip(KERR,1));
            %axis equal;
            %axis off;
            %colormap(summer);
            
            figure('Units', 'centimeters', 'Position',  [0, 0, 16, 16]);
            plot(reshape(P0,1,[]), reshape(KERR,1,[]), '.');
            xlabel('P0, mV');
            ylabel('\theta, \murad');
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

        curr = logdata.diode.current;
        dc = abs(logdata.voltmeter.v1);
        
        if isfield(logdata, 'sweep') && false
            n = numel(curr);
            k = logdata.sweep.rate-logdata.sweep.pause;
            m = fix(n/k);
            CURR = mean(reshape(curr, [k, m]),1);
            DC = mean(reshape(dc, [k, m]),1);
        else
            CURR = curr;
            DC = dc;
        end
        
        %DC = DC - DC(1);

        % New Focus 1601, 830 nm
        %sensitivity = -4.7;   % V/mW
        % New Focus 1801, 830 nm
        %sensitivity = 4.7;   % V/mW

        % Thorlabs PDA100A2, 50 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e5*0.63;   % V/mW

        % Thorlabs PDA100A2, 30 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e4*0.63;   % V/mW
        
        % Thorlabs PDA100A2, 20 dB gain, Hi-Z, 830 nm
        sensitivity = 1e-3*1.51*1e4*0.63;   % V/mW

        % Thorlabs PDA100A2, 10 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e3*0.63;   % V/mW

        % Thorlabs PDA100A2, 0 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*1.51*1e3*0.63;   % V/mW

        yyaxis(ax, 'left');
        plot(ax, CURR, 1e3*DC, 'k.-');
        ylim_left = ylim(ax);
        ylim_right = ylim_left/sensitivity;
        yyaxis(ax, 'right');
        plot(ax, CURR, 1e3*DC/sensitivity, 'k', 'LineStyle','none');
        ax.YAxis(2).Limits = ylim_right;
        
        
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
        %sensitivity = 4.7;   % V/mW

        % Thorlabs PDA100A2, 50 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e5*0.63;   % V/mW

        % Thorlabs PDA100A2, 30 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e4*0.63;   % V/mW
        
        % Thorlabs PDA100A2, 20 dB gain, Hi-Z, 830 nm
        sensitivity = 1e-3*1.51*1e4*0.63;   % V/mW

        % Thorlabs PDA100A2, 10 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*4.75*1e3*0.63;   % V/mW

        % Thorlabs PDA100A2, 0 dB gain, Hi-Z, 830 nm
        %sensitivity = 1e-3*1.51*1e3*0.63;   % V/mW

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
        axA = graphics.axes(1);
        axB = graphics.axes(2);
        cla(axA); yyaxis(axA, 'left'); cla(axA);

        v = logdata.source.V;
        vAx = 1e9*logdata.lockinA.X;    % Ixx, nA
        vBx = 1e6*logdata.lockinB.X;    % Vxx, uV
        curr = 1e9*logdata.source.I;    % leakadge current, nA
        
        yyaxis(axA, 'left');
        plot(axA, v, vAx, '.-r');
        yyaxis(axA, 'right');
        plot(axA, v, curr, '.-b');
        
        yyaxis(axB, 'left');
        plot(axB, v, vBx./vAx, '.-r');
        yyaxis(axB, 'right');
        
        

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

        volt = logdata.voltmeter.v1;
        %sensitivity = 1e-3*3.125;   %V/G
        sensitivity = 1e-9*550;   %V/G
        field = (volt-volt(1))/sensitivity;
        %field = volt/sensitivity;

        plot(ax, curr, field, '.-r');
        
    case 11682  %cv: Capacitance vs voltage
        ax = graphics.axes;
        cla(ax);

        volt = 1e3*logdata.lockin.AUXV1;
        cap = logdata.bridge.C;

        plot(ax, volt, cap, '.-r');
        
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
        
        
    case 10593  %kc: kerr vs strain (capacitance)
        axisA = graphics.axes(1);
        axisB = graphics.axes(2);
        for ax = graphics.axes
            yyaxis(ax, 'right'); cla(ax); 
            yyaxis(ax, 'left'); cla(ax);
        end

        sls = .25;                                      % second lockin sensitivity
        L_gap = 40;                                     % um
        L_smp = 1600;                                   % um
        curr = .1;                                      % 1 mA x 100 gain
        
        v  = 1e3*logdata.lockinA.AUXV1;                  % Strain voltage, mV
        C  = logdata.bridge.C;                          % Capacitance, pF
        C0 = mean(C);
        e  = -100*(L_gap/L_smp)*(C-C0)/C0;              % strain, %
        
        v0  = 1e3*logdata.voltmeter.v1;                 % DC Volt, mV
        v1X = 1e6*logdata.lockin.X;                     % 1st harm Volt X, uV
        v1Y = 1e6*logdata.lockin.Y;                     % 1st harm Volt Y, uV
        v2X = sls*1e3*logdata.lockin.AUX1;              % 2nd harm Volt X, mV
        v2Y = sls*1e3*logdata.lockin.AUX2;              % 2nd harm Volt Y, mV
        r = logdata.lockinA.X/curr;                     % Resistnace, Ohms

        c = besselj(2,1.841)/besselj(1,1.841);
        v2 = sqrt(v2X.^2+v2Y.^2);
        kerr = .5*atan(c*(v1X*1e-3)./v2)*1e6;
        
        
        n = numel(kerr);
        k = logdata.sweep.rate-logdata.sweep.pause;
        k = k(1);
        m = fix(n/k);
        KERR = mean(reshape(kerr, [k, m]),1);
        KERRstd = std(reshape(kerr, [k, m]),0,1);
        E = mean(reshape(e, [k, m]),1);
        R = mean(reshape(r, [k, m]),1);
        V = mean(reshape(v, [k, m]),1);
        
        
        yyaxis(axisA, 'right');
        plot(axisA, V, R, 'b--');
        yyaxis(axisA, 'left');
        plot(axisA, V, KERR, 'r.-');
        
        yyaxis(axisB, 'left');
        plot(axisB, v, C, 'r');
        yyaxis(axisB, 'right');
        plot(axisB, v, e, 'b');


    otherwise
        disp("Unknown seed.")
end
