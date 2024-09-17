function graphics = zx(graphics, logdata, options)
%Graphics plotting function.

arguments
    graphics struct;
    logdata struct;
    options.cutoff (1,1) logical = true;
    options.knife_edge (1,1) logical = true;
end

ax = graphics.axes;
yyaxis(ax, 'left'); cla(ax); 
yyaxis(ax, 'right'); cla(ax);


y = logdata.X.position;                         
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
        if numel(Y) > fix(numel(logdata.sweep.range)*0.98)
            Y = (Y - Y(1));
            V0 = V0-(V0(end)+.5*(V0(1)-V0(end)));
            if V0(1) > V0(end)
                V0 = -V0;
            end
            xlabel(ax, 'Position, \mum');
            eqn = 'a*erf(sqrt(2)*(x-b)/c)';
            [f, ~] = fit(Y.', V0.', eqn, 'Start', [200, 600, 150]);

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

yyaxis(ax, 'left');
plot(ax, Y, KERR, 'r.-');
yyaxis(ax, 'right');
plot(ax, Y, V0, 'b.-');
yyaxis(ax, 'left');                
