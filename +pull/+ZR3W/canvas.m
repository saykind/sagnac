function graphics = canvas()
%Graphics initialization function.

    fig = plot.paper.measurement(subplots=[0,0], title = "Resistance vs Temperature");
    tg = uitabgroup(fig);
    tab_time = uitab(tg, 'Title', 'Volt, Temp vs Time');
    tab_res = uitab(tg, 'Title', 'Res, Kerr vs Angle');
    tab_volt = uitab(tg, 'Title', 'Curr, Volt vs Angle');

    %% Parameters
    min_angle = 45;
    max_angle = 230;
    step_angle = 15;

    %% TAB: Time 
    [~, ax_time] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_time, ...
        subplots = [2,1], ...
        xlabel = "Time (min)");

    % Set axis labels
    yyaxis(ax_time(1), 'left');
    ylabel(ax_time(1), "V_{bg} (V)");
    yyaxis(ax_time(1), 'right');
    ylabel(ax_time(1), "Reflected DC (mV)");

    yyaxis(ax_time(2), 'left');
    ylabel(ax_time(2), "Temperature A (K)");
    yyaxis(ax_time(2), 'right');
    ylabel(ax_time(2), "Temperature B (K)");

    %% TAB: Resistance
    [~, ax_res] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_res, ...
        subplots = [2,1], ...
        xlim = [min_angle, max_angle], ...
        xlabel = "Waveplate Angle (deg)");

    % Set axis labels    
    yyaxis(ax_res(1), 'left');
    ylabel(ax_res(1), "R_{xx} (kOhm)");
    yyaxis(ax_res(1), 'right');
    ylabel(ax_res(1), "R_{yx} (kOhm)");

    yyaxis(ax_res(2), 'left');
    ylabel(ax_res(2), "Re V_{yx} (uV)");
    yyaxis(ax_res(2), 'right');
    ylabel(ax_res(2), "Im V_{yx} (uV)");

    % Set xticks with step_angle degree step
    xticks(ax_res(1), min_angle:step_angle:max_angle);
    xticks(ax_res(2), min_angle:step_angle:max_angle);

    %% TAB: Photocurrent
    [~, ax_volt] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_volt, ...
        subplots = [2,1], ...
        xlim = [min_angle, max_angle], ...
        xlabel = "Waveplate Angle (deg)");

    % Set axis labels    
    yyaxis(ax_volt(1), 'left');
    ylabel(ax_volt(1), "Re I_{xx} (pA)");
    yyaxis(ax_volt(1), 'right');
    ylabel(ax_volt(1), "Im I_{xx} (pA)");

    yyaxis(ax_volt(2), 'left');
    ylabel(ax_volt(2), "Re V_{xx} (uV)");
    yyaxis(ax_volt(2), 'right');
    ylabel(ax_volt(2), "Im V_{xx} (uV)");

    % Set xticks with step_angle degree step
    xticks(ax_volt(1), min_angle:step_angle:max_angle);
    xticks(ax_volt(2), min_angle:step_angle:max_angle);


    %% Epiloge
    % Set font size
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 12);

    axs = cat(1, ax_time, ax_res, ax_volt);
    graphics = struct('figure', fig, 'axes', axs);

end