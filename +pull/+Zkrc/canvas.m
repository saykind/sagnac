function graphics = canvas()
%Graphics initialization function.

    fig = plot.paper.measurement(subplots=[0,0], title = "Elasto-magneto-optics");
    tg = uitabgroup(fig);
    tab_temp = uitab(tg, 'Title', 'Temperature');
    tab_kerr = uitab(tg, 'Title', 'Kerr Angle');
    tab_tran = uitab(tg, 'Title', 'Transport');

    %% TAB: Temp vs time 
    [~, ax_temp] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_temp, ...
        right_yaxis = false, ...
        subplots = [2,1], ...
        xlabel = "Time (min)");

    % Set axis labels
    ylabel(ax_temp(1), "Sample Temperature");
    ylabel(ax_temp(2), "Temperature B");

    %% TAB: Kerr vs temp
    [~, ax_kerr] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_kerr, ...
        subplots = [2,1], ...
        xlabel = "Temperature (K)");

    % Set axis labels    
    yyaxis(ax_kerr(1), 'left');
    ylabel(ax_kerr(1), "Kerr Angle, \murad");
    yyaxis(ax_kerr(1), 'right');
    ylabel(ax_kerr(1), "DC Voltage (mV)");

    yyaxis(ax_kerr(2), 'left');
    ylabel(ax_kerr(2), "X_{1\omega} (uV)");
    yyaxis(ax_kerr(2), 'right');
    ylabel(ax_kerr(2), "R_{2\omega} (mV)");

    %% TAB: Transport vs temp, time
    [~, ax_tran] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_tran, ...
        subplots = [2,1], ...
        single_xticks = false, ...
        xlabel = "Temperature (K)");
    
    % Set axis labels    
    yyaxis(ax_tran(1), 'left');
    ylabel(ax_tran(1), "Resistance, mOhm");
    yyaxis(ax_tran(1), 'right');
    ylabel(ax_tran(1), "Strain, %");
    xlabel(ax_tran(1), "Temperature (K)");

    yyaxis(ax_tran(2), 'left');
    ylabel(ax_tran(2), "Resistance, mOhm");
    yyaxis(ax_tran(2), 'right');
    ylabel(ax_tran(2), "Capacitance, pF");
    xlabel(ax_tran(2), "Time (min)");

    %% Epiloge
    % Set font size
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 12);

    ax = cat(1, ax_temp, ax_kerr, ax_tran);
    graphics = struct('figure', fig, 'axes', ax);

end