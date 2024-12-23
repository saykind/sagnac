function graphics = zx(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.cutoff (1,1) logical = true;
    options.knife_edge (1,1) logical = false;
    options.linear_fit (1,1) logical = true;
end

ax = graphics.axes;
yyaxis(ax, 'left'); cla(ax); 
yyaxis(ax, 'right'); cla(ax);


y = logdata.Y.position;                         
v0  = 1e3*logdata.voltmeter.v1;                 % DC Power, uW
[x1, y1, x2, y2, r1, r2, kerr] = ...
    util.logdata.lockin(logdata.lockin);

n = numel(kerr);
k = logdata.sweep.rate-logdata.sweep.pause;
k = k(1);
m = fix(n/k);
KERR = mean(reshape(kerr, [k, m]),1);
V0 = mean(reshape(v0, [k, m]),1);
Y = mean(reshape(y, [k, m]),1);
Y = Y - logdata.sweep.origin;
Y = Y*1e3;  % convert mm to um

%Knife edge
if options.knife_edge
    if numel(Y) >= fix(numel(logdata.sweep.range)*0.999)
        Y = (Y - Y(1));
        V0 = V0-(V0(end)+.5*(V0(1)-V0(end)));
        if V0(1) > V0(end)
            V0 = -V0;
        end
        xlabel(ax, 'Position, \mum');
        eqn = 'a*erf(sqrt(2)*(x-b)/c)';
        [f, ~] = fit(Y.', V0.', eqn, 'Start', [300, 20, 5]);

        Yf = linspace(min(Y), max(Y), 1e3);
        Zf = f.a*erf(sqrt(2)*(Yf-f.b)/f.c); 

        cf = confint(f);
        disp(f.a);
        disp(f.b);
        fprintf("Radius = %.2f um (%.2f, %.2f)\n", f.c, cf(:,3)');
        
        yyaxis(ax, 'right');
        plot(ax, Yf, Zf, 'k--');
        yyaxis(ax, 'left');
    end
end

% Linear fir kerr vs 1./dc
if options.linear_fit
    [p, ~] = polyfit(1./V0, KERR, 1);
    V0_linear = linspace(min(1./V0), max(1./V0), 100);
    kerr_linear = polyval(p, V0_linear);
    disp_name = sprintf('%.0f urad*mV + %.2f urad', p(1), p(2));
    disp(disp_name);
    KERR = KERR - polyval(p, 1./V0);
end

yyaxis(ax, 'left');
plot(ax, Y, KERR, 'r.-');
yyaxis(ax, 'right');
plot(ax, Y, V0, 'b.-');
yyaxis(ax, 'left');     

