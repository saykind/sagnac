function graphics = canvas()
%Graphics initialization function.

    fig = plot.paper.measurement(subplots=[0,0], title = "Strain sweep");

    [~, ax] = plot.paper.measurement(...
        fig = fig, ...
        subplots = [3,1], ...
        single_xticks = false, ...
        xlabel = "Magnetic field (mT)");

    % Set axis labels
    yyaxis(ax(1), 'left');
    ylabel(ax(1), "Kerr angle (\murad)");    
    yyaxis(ax(1), 'right');    
    ylabel(ax(1), "DC voltage (mV)");  
    
    yyaxis(ax(2), 'left');
    ylabel(ax(2), "Temprature A (K)");  
    yyaxis(ax(2), 'right');
    ylabel(ax(2), "Temprature B (K)");
    xlabel(ax(2), "Magnetic field (mT)");

    yyaxis(ax(3), 'left');
    ylabel(ax(3), "Magnetic current (A)");  
    yyaxis(ax(3), 'right');
    ylabel(ax(3), "Magnetic voltage (V)");
    xlabel(ax(3), "Time (min)");

    %% Epiloge
    % Set font size
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 12);

    axs = cat(1, ax);
    graphics = struct('figure', fig, 'axes', axs);

end