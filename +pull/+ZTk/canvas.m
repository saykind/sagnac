function graphics = canvas()
%Graphics initialization function.

    fig = plot.paper.measurement(subplots=[0,0], title = "Amplitude sweep");
    tg = uitabgroup(fig);
    tab_temp = uitab(tg, 'Title', 'Temp');
    tab_kerr_temp = uitab(tg, 'Title', 'Kerr vs temp');
    tab_kerr_time = uitab(tg, 'Title', 'Kerr vs time');

    %% TAB: Temp
    [~, ax_temp] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_temp, ...
        right_yaxis = false, ...
        subplots = [2,1], ...
        xlabel = "Time (min)");

    % Set axis labels
    ylabel(ax_temp(1), "Temperature A (K)");
    ylabel(ax_temp(2), "Temperature B (K)");


    %% TAB: Kerr vs temp
    [~, ax_kerr_temp] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_kerr_temp, ...
        subplots = [3,1], ...
        xlabel = "Temperature (K)");

    % Set axis labels    
    yyaxis(ax_kerr_temp(1), 'left');
    ylabel(ax_kerr_temp(1), "Kerr Angle, \murad");
    yyaxis(ax_kerr_temp(1), 'right');
    ylabel(ax_kerr_temp(1), "DC Voltage (mV)");

    yyaxis(ax_kerr_temp(2), 'left');
    ylabel(ax_kerr_temp(2), "X_{1\omega} (uV)");
    yyaxis(ax_kerr_temp(2), 'right');
    ylabel(ax_kerr_temp(2), "Y_{1\omega} (uV)");

    yyaxis(ax_kerr_temp(3), 'left');
    ylabel(ax_kerr_temp(3), "R_{2\omega} (mV)");
    yyaxis(ax_kerr_temp(3), 'right');
    ylabel(ax_kerr_temp(3), "R_{2\omega}/DC");

    %% TAB: Kerr vs time
    [~, ax_kerr_time] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_kerr_time, ...
        subplots = [3,1], ...
        xlabel = "Time (min)");
    
    % Set axis labels
    yyaxis(ax_kerr_time(1), 'left');
    ylabel(ax_kerr_time(1), "Kerr Angle, \murad");
    yyaxis(ax_kerr_time(1), 'right');
    ylabel(ax_kerr_time(1), "DC Voltage (mV)");

    yyaxis(ax_kerr_time(2), 'left');
    ylabel(ax_kerr_time(2), "X_{1\omega} (uV)");
    yyaxis(ax_kerr_time(2), 'right');
    ylabel(ax_kerr_time(2), "Y_{1\omega} (uV)");

    yyaxis(ax_kerr_time(3), 'left');
    ylabel(ax_kerr_time(3), "R_{2\omega} (mV)");
    yyaxis(ax_kerr_time(3), 'right');
    ylabel(ax_kerr_time(3), "R_{2\omega}/DC");


    %% Epiloge
    % Set font size
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 12);

    ax = cat(1, ax_temp, ax_kerr_temp, ax_kerr_time);
    graphics = struct('figure', fig, 'axes', ax);

end