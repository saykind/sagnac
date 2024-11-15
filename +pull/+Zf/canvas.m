function graphics = canvas()
%Graphics initialization function.

    fig = plot.paper.measurement(subplots=[0,0], title = "Frequency sweep");
    tg = uitabgroup(fig);
    tab_norm = uitab(tg, 'Title', 'Normalized Magnitude');
    tab_1f = uitab(tg, 'Title', 'First Harm (1f)');
    tab_2f = uitab(tg, 'Title', 'Second Harm (2f)');
    tab_3f = uitab(tg, 'Title', 'Third Harm (3f)');
    tab_4f = uitab(tg, 'Title', 'Fourth Harm (4f)');

    %% TAB: Normalized 
    [~, ax_norm] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_norm, ...
        right_yaxis = false, ...
        subplots = [3,1], ...
        xlabel = "Modulation Frequency (MHz)");

    % Set axis labels
    ylabel(ax_norm(1), "DC_1, mV");
    ylabel(ax_norm(2), "10^3 R_{1\omega}/DC");
    ylabel(ax_norm(3), "10^3 R_{2\omega}/DC");

    %% TAB: 1f
    [~, ax_1f] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_1f, ...
        subplots = [2,1], ...
        xlabel = "Modulation Frequency (MHz)");

    % Set axis labels    
    yyaxis(ax_1f(1), 'left');
    ylabel(ax_1f(1), "R_{1\omega}, mV");
    yyaxis(ax_1f(1), 'right');
    ylabel(ax_1f(1), "\Theta_{1\omega}, deg");

    yyaxis(ax_1f(2), 'left');
    ylabel(ax_1f(2), "X_{1\omega}, mV");
    yyaxis(ax_1f(2), 'right');
    ylabel(ax_1f(2), "Y_{1\omega}, mV");

    [~, ax_2f] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_2f, ...
        subplots = [2,1], ...
        xlabel = "Modulation Frequency (MHz)");
    
    % Set axis labels    
    yyaxis(ax_2f(1), 'left');
    ylabel(ax_2f(1), "R_{2\omega}, mV");
    yyaxis(ax_2f(1), 'right');
    ylabel(ax_2f(1), "\Theta_{2\omega}, deg");

    yyaxis(ax_2f(2), 'left');
    ylabel(ax_2f(2), "X_{2\omega}, mV");
    yyaxis(ax_2f(2), 'right');
    ylabel(ax_2f(2), "Y_{2\omega}, mV");

    %% TAB: 3f
    [~, ax_3f] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_3f, ...
        subplots = [2,1], ...
        xlabel = "Modulation Frequency (MHz)");

    % Set axis labels
    yyaxis(ax_3f(1), 'left');
    ylabel(ax_3f(1), "R_{3\omega}, mV");
    yyaxis(ax_3f(1), 'right');
    ylabel(ax_3f(1), "\Theta_{3\omega}, deg");

    yyaxis(ax_3f(2), 'left');
    ylabel(ax_3f(2), "X_{3\omega}, mV");
    yyaxis(ax_3f(2), 'right');
    ylabel(ax_3f(2), "Y_{3\omega}, mV");

    %% TAB: 4f
    [~, ax_4f] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_4f, ...
        subplots = [2,1], ...
        xlabel = "Modulation Frequency (MHz)");

    % Set axis labels
    yyaxis(ax_4f(1), 'left');
    ylabel(ax_4f(1), "R_{4\omega}, mV");
    yyaxis(ax_4f(1), 'right');
    ylabel(ax_4f(1), "\Theta_{4\omega}, deg");

    yyaxis(ax_4f(2), 'left');
    ylabel(ax_4f(2), "X_{4\omega}, mV");
    yyaxis(ax_4f(2), 'right');
    ylabel(ax_4f(2), "Y_{4\omega}, mV");

    %% Epiloge
    % Set font size
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 12);

    ax = cat(1, ax_norm, ax_1f, ax_2f, ax_3f, ax_4f);
    graphics = struct('figure', fig, 'axes', ax);

end