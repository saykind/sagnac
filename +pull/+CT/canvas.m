function graphics = canvas()
%Graphics initialization function.

    fig = plot.paper.measurement(subplots=[0,0], title = "Strain sweep");

    [~, ax] = plot.paper.measurement(...
        fig = fig, ...
        subplots = [2,1], ...
        single_xticks = false, ...
        xlabel = "Time (min)");

    % Set axis labels
    yyaxis(ax(1), 'left');
    ylabel(ax(1), "strain, %");    
    yyaxis(ax(1), 'right');    
    ylabel(ax(1), "Capacitance, pF");   
    xlabel(ax(1), "Time (min)");
    
    yyaxis(ax(2), 'left');
    ylabel(ax(2), "Temperature A, K");  
    yyaxis(ax(2), 'right');
    ylabel(ax(2), "Temperature B, K");
    xlabel(ax(2), "datetime");

    %% Epiloge
    % Set font size
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 12);

    axs = cat(1, ax);
    graphics = struct('figure', fig, 'axes', axs);

end