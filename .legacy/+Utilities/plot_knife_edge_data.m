function plot_knife_edge_data(filename)

if nargin < 1
    filename = 'knife_edge_data.mat';
end
logdata = load(filename, 'logdata').logdata;

logdata.y = logdata.y-.5*(logdata.y(1)+logdata.y(end));

%% Fit

eqn = 'a*erf(sqrt(2)*(x-b)/c)';
[f, gof] = fit(logdata.x', logdata.y', eqn, 'Start', [-100, 100, 25]);

X = linspace(min(logdata.x), max(logdata.x), 1e3);
Y = f.a*erf(sqrt(2)*(X-f.b)/f.c); 

cf = confint(f);
fprintf("Radius = %.2f um (%.2f, %.2f)\n", f.c, cf(:,3)');


%% Plot
fig = figure('Name', 'Knife Edge Measurement');
ax = axes(fig);
errorbar(ax, logdata.x, logdata.y, logdata.y_err, '.');
hold(ax, 'on');
plot(ax, X, Y);
xlabel(ax, 'Distance, \mum');
ylabel(ax, 'Intensity, mV');
grid(ax, 'on');

end