function graphics = canvas()
%Graphics initialization function.

    [fig, ax] = plot.paper.measurement(...
        subplots = [2,1], ...
        single_xticks = false);

    % Set axis labels
    title(ax(1), "LSCI 331");
    yyaxis(ax(1), 'left');
    ylabel(ax(1), "Temp A (K)");
    yyaxis(ax(1), 'right');
    ylabel(ax(1), "Temp B (K)");
    xlabel(ax(1), "Time (min)");

    title(ax(2), "LSCI 340");
    yyaxis(ax(2), 'left');
    ylabel(ax(2), "Temp A (K)");
    yyaxis(ax(2), 'right');
    ylabel(ax(2), "Temp B (K)");

    graphics = struct('figure', fig, 'axes', ax);

end