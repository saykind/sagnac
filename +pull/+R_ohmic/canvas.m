function graphics = canvas()
%Graphics initialization function.

    fig = plot.paper.measurement(subplots=[0,0], title = "Current sweep");

    [~, ax] = plot.paper.measurement(...
        fig = fig, ...
        title = "Current sweep", ...
        subplots = [2,1], ...
        xlabel = "Input Current, nA");

    % Set axis labels
    yyaxis(ax(1), 'left');
    ax(1).YColor = 'k';
    ylabel(ax(1), "Resistance, kOhm");
    yyaxis(ax(1), 'right');
    ylabel(ax(1), "Phase, deg");
    
    yyaxis(ax(2), 'left');
    ylabel(ax(2), "V_X, uV");  

    yyaxis(ax(2), 'right');
    ylabel(ax(2), "V_Y, uV");

    %% Epiloge
    % Set font size
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 12);

    axs = cat(1, ax);
    graphics = struct('figure', fig, 'axes', axs);

end