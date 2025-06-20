function graphics = canvas()
%Graphics initialization function.

    fig = plot.paper.measurement(subplots=[0,0], title = "Current sweep");
    tg = uitabgroup(fig);
    tab_res = uitab(tg, 'Title', 'Resistance');
    tab_volt = uitab(tg, 'Title', 'Voltage');

    %% TAB: Resistance 
    [~, ax_res] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_res, ...
        right_yaxis = false, ...
        subplots = [1,1], ...
        xlabel = "Current (nA)");

    % Set axis labels
    ylabel(ax_res(1), "R_{xx}, kOhm");

    %% TAB: Voltage
    [~, ax_volt] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_volt, ...
        subplots = [2,1], ...
        xlabel = "Input Voltage (mV)");

    % Set axis labels    
    yyaxis(ax_volt(1), 'left');
    ylabel(ax_volt(1), "I_{xx} (nA)");
    yyaxis(ax_volt(1), 'right');
    ylabel(ax_volt(1), "Phase, deg");

    yyaxis(ax_volt(2), 'left');
    ylabel(ax_volt(2), "V_{xx}^X (uV)");
    yyaxis(ax_volt(2), 'right');
    ylabel(ax_volt(2), "V_{xx}^Y (uV)");


    %% Epiloge
    % Set font size
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 12);

    axs = cat(1, ax_res, ax_volt);
    graphics = struct('figure', fig, 'axes', axs);

end