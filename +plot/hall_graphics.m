function [fig, axes] = hall_graphics(title, parametername)
    %Creates fig, axes for plt.hall()
    
    % Configure Figure
    fig = figure('Name', title, ...
        'Units', 'centimeters', ...
        'Position', [0 0 20.5 12.9]);
    set(fig, 'PaperUnits', 'centimeters', 'PaperSize', [11 9]);
    t = tiledlayout(fig, 2, 2);
    ax1 = nexttile(t); ax2 = nexttile(t);
    ax3 = nexttile(t); ax4 = nexttile(t);
    axes = [ax1, ax2, ax3, ax4];
    hold(ax1, 'on'); grid(ax1, 'on'); box(ax1, 'on');
    hold(ax2, 'on'); grid(ax2, 'on'); box(ax2, 'on');
    hold(ax3, 'on'); grid(ax3, 'on'); box(ax3, 'on');
    hold(ax4, 'on'); grid(ax4, 'on'); box(ax4, 'on');

    title(ax1, "R_{xy}^{31}");
    
    yyaxis(ax1, 'left');
    set(ax1, 'YColor', 'r');
    ylabel(ax1, 'Re V_{xy}, mV');
    
    yyaxis(ax1, 'right');
    set(ax1, 'YColor', 'b');
    ylabel(ax1, 'Im V_{xy}, mV');
    
    yyaxis(ax3, 'left');
    set(ax3, 'YColor', 'r');
    ylabel(ax3, 'Mag V_{xy}, mV');
    
    yyaxis(ax3, 'right');
    set(ax3, 'YColor', 'b');
    ylabel(ax3, 'Phase V_{xy}, deg');
    
    title(ax2, "R_{xy}^{ac}");
    
    yyaxis(ax2, 'left');
    set(ax2, 'YColor', 'r');
    ylabel(ax2, 'Re V_{xy}, V');
    
    yyaxis(ax2, 'right');
    set(ax2, 'YColor', 'b');
    ylabel(ax2, 'Im V_{xy}, V');
    
    yyaxis(ax4, 'left');
    set(ax4, 'YColor', 'r');
    ylabel(ax4, 'Mag V_{xy}, mV');
    
    yyaxis(ax4, 'right');
    set(ax4, 'YColor', 'b');
    ylabel(ax4, 'Phase V_{xy}, deg');
    
    xlabel(ax3, parametername);
    xlabel(ax4, parametername);
end