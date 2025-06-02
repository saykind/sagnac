function graphics = canvas()
%Graphics initialization function.

    fig = plot.paper.measurement(subplots=[0,0], title = "Resistance vs Temperature");
    tg = uitabgroup(fig);
    tab_res = uitab(tg, 'Title', 'Temp vs Time');
    tab_volt = uitab(tg, 'Title', 'Res vs Field');

    %% TAB: Resistance 
    [~, ax_time] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_res, ...
        subplots = [2,1], ...
        xlabel = "Time (min)");

    % Set axis labels
    yyaxis(ax_time(1), 'left');
    ylabel(ax_time(1), "Magnet Current (A)");
    yyaxis(ax_time(1), 'right');
    ylabel(ax_time(1), "Bottom Gate Voltage (V)");

    yyaxis(ax_time(2), 'left');
    ylabel(ax_time(2), "Temperature A (K)");
    yyaxis(ax_time(2), 'right');
    ylabel(ax_time(2), "Temperature B (K)");

    %% TAB: Voltage
    [~, ax_volt] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_volt, ...
        subplots = [2,1], ...
        xlabel = "Magnetic Field (mT)");

    % Set axis labels    
    yyaxis(ax_volt(1), 'left');
    ylabel(ax_volt(1), "R_{yx} (kOhm)");

    yyaxis(ax_volt(2), 'left');
    ylabel(ax_volt(2), "I_{xx}, (nA)");


    %% Epiloge
    % Set font size
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 12);

    axs = cat(1, ax_time, ax_volt);
    graphics = struct('figure', fig, 'axes', axs);

end