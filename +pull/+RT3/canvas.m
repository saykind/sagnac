function graphics = canvas()
%Graphics initialization function.

    fig = plot.paper.measurement(subplots=[0,0], title = "Resistance vs Temperature");
    tg = uitabgroup(fig);
    tab_res = uitab(tg, 'Title', 'Resistance');
    tab_volt = uitab(tg, 'Title', 'Voltage');

    %% TAB: Resistance 
    [~, ax_res] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_res, ...
        subplots = [2,1], ...
        single_xticks = false, ...
        xlabel = "Sample Temperature (K)");

    % Set axis labels
    yyaxis(ax_res(1), 'left');
    ylabel(ax_res(1), "R_{xx} (kOhm)");
    yyaxis(ax_res(1), 'right');
    ylabel(ax_res(1), "R_{yx} (kOhm)");
    xlabel(ax_res(1), "Sample Temperature (K)");

    yyaxis(ax_res(2), 'left');
    ylabel(ax_res(2), "Temperature A (K)");
    yyaxis(ax_res(2), 'right');
    ylabel(ax_res(2), "Temperature B (K)");
    xlabel(ax_res(2), "Time (min)");

    %% TAB: Voltage
    [~, ax_volt] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_volt, ...
        subplots = [3,1], ...
        xlabel = "Sample Temperature (K)");

    % Set axis labels    
    yyaxis(ax_volt(1), 'left');
    ylabel(ax_volt(1), "I_{xx} (nA)");
    yyaxis(ax_volt(1), 'right');
    ylabel(ax_volt(1), "Phase, deg");

    yyaxis(ax_volt(2), 'left');
    ylabel(ax_volt(2), "V_{xx}^X (uV)");
    yyaxis(ax_volt(2), 'right');
    ylabel(ax_volt(2), "V_{xx}^Y (uV)");

    yyaxis(ax_volt(3), 'left');
    ylabel(ax_volt(3), "V_{yx}^X (uV)");
    yyaxis(ax_volt(3), 'right');
    ylabel(ax_volt(3), "V_{yx}^Y (uV)");


    %% Epiloge
    % Set font size
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 12);

    axs = cat(1, ax_res, ax_volt);
    graphics = struct('figure', fig, 'axes', axs);

end