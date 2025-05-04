function graphics = canvas()
%Graphics initialization function.

    fig = plot.paper.measurement(subplots=[0,0], title = "Resistance vs Temperature");
    tg = uitabgroup(fig);
    tab_res = uitab(tg, 'Title', 'Voltage vs Time');
    tab_volt = uitab(tg, 'Title', 'Res, Kerr vs Voltage');

    %% TAB: Resistance 
    [~, ax_time] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_res, ...
        subplots = [2,1], ...
        xlabel = "Time (min)");

    % Set axis labels
    yyaxis(ax_time(1), 'left');
    ylabel(ax_time(1), "V_{bg} (V)");
    yyaxis(ax_time(1), 'right');
    ylabel(ax_time(1), "I_{bg} (nA)");

    yyaxis(ax_time(2), 'left');
    ylabel(ax_time(2), "Temperature A (K)");
    yyaxis(ax_time(2), 'right');
    ylabel(ax_time(2), "Temperature B (K)");

    %% TAB: Voltage
    [~, ax_volt] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_volt, ...
        subplots = [2,1], ...
        xlabel = "Bottom Gate Voltage (V)");

    % Set axis labels    
    yyaxis(ax_volt(1), 'left');
    ylabel(ax_volt(1), "Re I_{xx}, (nA)");
    yyaxis(ax_volt(1), 'right');
    ylabel(ax_volt(1), "Im I_{xx}, (nA)");

    yyaxis(ax_volt(2), 'left');
    ylabel(ax_volt(2), "Re V_{xx}, uV");
    yyaxis(ax_volt(2), 'right');
    ylabel(ax_volt(2), "Im V_{xx}, uV");


    %% Epiloge
    % Set font size
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 12);

    axs = cat(1, ax_time, ax_volt);
    graphics = struct('figure', fig, 'axes', axs);

end