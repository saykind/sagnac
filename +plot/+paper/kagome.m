function [fig, axs] = kagome(options)
%GRAPHICS Create a figure and axis for two panel graphics.

arguments
    options.fontsize double {mustBeNumeric} = 9;
    options.xlim double {mustBeNumeric} = [0, 150];
    options.xticks double {mustBeNumeric} = 0:30:150;
    options.ylim_top double {mustBeNumeric} = [-.7, .7];
    options.ylim_bottom double {mustBeNumeric} = [-.35, .35];
    options.yticks_top double {mustBeNumeric} = .1*(-10:2:10);
    options.yticks_bottom double {mustBeNumeric} = .1*(-5:1:5);
    options.subfigure_label_top string = 'a';
    options.subfigure_label_bottom string = 'b';
end

    fig = figure('Units', 'centimeters', 'Position', [1 2 8.6 7.6]);
    
    ax_if = subplot(2, 1, 1, 'FontSize', 10, 'FontName', 'Arial');
    set(ax_if, 'Position', [0.1750, 0.5, 0.78, 0.425] ) ;
    hold(ax_if, 'on');
    grid(ax_if, 'on');
    box(ax_if, 'on');
    xlim(ax_if, options.xlim);
    ylim(ax_if, options.ylim_top);
    yticks(options.yticks_top);
    ylabel(ax_if, '\Delta\theta_K (urad)');
    yline(ax_if, 0, 'Color', 'k', 'LineStyle', '--', 'LineWidth', 0.5);
    xticks(options.xticks);
    
    ax_zf = subplot(2, 1, 2, 'FontSize', 10, 'FontName', 'Arial');
    set( ax_zf, 'Position', [0.1750, 0.1400, 0.78, 0.3412] ) ;
    hold(ax_zf, 'on');
    grid(ax_zf, 'on');
    box(ax_zf, 'on');
    xlim(ax_zf, options.xlim);
    xlabel(ax_zf, 'Temperature (K)');
    ylim(ax_zf, options.ylim_bottom);
    yticks(options.yticks_bottom);
    ylabel(ax_zf, '\theta_K (urad)');
    yline(ax_zf, 0, 'Color', 'k', 'LineStyle', '--', 'LineWidth', 0.5);
    
    set(ax_if ,'xticklabel', {});
    xticks(options.xticks);

    % Subfigure labels
    fontsize = options.fontsize;
    text(ax_if, -0.2, 1.05, options.subfigure_label_top, ...
        'FontSize', fontsize+1, ...
        'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'top', ...
        'Units', 'normalized');
    text(ax_zf, -0.2, 1.05, options.subfigure_label_bottom, ...
        'FontSize', fontsize+1, ...
        'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'top', ...
        'Units', 'normalized');

    axs = [ax_if, ax_zf];