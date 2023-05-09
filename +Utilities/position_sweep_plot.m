function position_sweep_plot(filename)

if nargin < 1
    filename = 'position_sweep.mat';
end
logdata = load(filename, 'logdata').logdata;

%% Plot
fig = figure('Name', 'Kerr angle - position sweep');
ax = axes(fig);
hold(ax, 'on');
grid(ax, 'on');

yyaxis(ax, 'left');
errorbar(ax, logdata.position, 1e6*logdata.kerr, 2*1e6*logdata.kerr_err, '.');
xlabel(ax, 'Distance, \mum');
ylabel(ax, 'Kerr angle, \murad');

yyaxis(ax, 'right');
plot(ax, logdata.position, 1e3*logdata.dc, '-');
ylabel(ax, 'DC, mV');


end