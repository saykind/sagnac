function graphics = canvas()
%Graphics initialization function.

    fig = plot.paper.measurement(subplots=[0,0], title = "Strain sweep");

    [~, ax] = plot.paper.measurement(...
        fig = fig, ...
        subplots = [3,1], ...
        single_xticks = false, ...
        xlabel = "AUXV1 (V)");

    % Set axis labels
    yyaxis(ax(1), 'left');
    ylabel(ax(1), "strain, %");    
    yyaxis(ax(1), 'right');    
    ylabel(ax(1), "d, \mum");   
    xlabel(ax(1), "25*AUXV1, V");

    
    yyaxis(ax(2), 'left');
    ylabel(ax(2), "Resistance, Ohm");  
    yyaxis(ax(2), 'right');
    ylabel(ax(2), "Capacitance, pF");
    xlabel(ax(2), "AUXV1, V");

    yyaxis(ax(3), 'left');
    ylabel(ax(3), "Resistance, Ohm");  
    yyaxis(ax(3), 'right');
    ylabel(ax(3), "Capacitance, pF");
    xlabel(ax(3), "strain, %");

    %% Epiloge
    % Set font size
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 12);

    axs = cat(1, ax);
    graphics = struct('figure', fig, 'axes', axs);

end