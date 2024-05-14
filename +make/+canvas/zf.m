function graphics = zf()
%Graphics initialization function.

    f = figure('Units', 'centimeters');

    set(f,  'Position',  [0, 0, 22, 18]);

    tabgroup = uitabgroup(f);
    tab_dc = uitab(tabgroup, 'Title', 'DC and Kerr');
    tab_x1y1 = uitab(tabgroup, 'Title', '1f Harmonic');
    tab_x2y2 = uitab(tabgroup, 'Title', '2f Harmonic');

    tl_dc = tiledlayout(tab_dc, 2, 1);
    tl_x1y1 = tiledlayout(tab_x1y1, 2, 1);
    tl_x2y2 = tiledlayout(tab_x2y2, 2, 1);

    axis_dc = nexttile(tl_dc);
    axis_kerr = nexttile(tl_dc);

    axis_x1y1 = nexttile(tl_x1y1);
    axis_r1q1 = nexttile(tl_x1y1);

    axis_x2y2 = nexttile(tl_x2y2);
    axis_r2q2 = nexttile(tl_x2y2);


    a = [axis_dc, axis_kerr, ...
         axis_x1y1, axis_r1q1, ...
         axis_x2y2, axis_r2q2];

    graphics = struct('figure', f, 'axes', a);

    axes_titles = ["DC voltage V_0, mV", "Kerr signal \theta, \murad", ...
                   "1f Harmonic X and Y, \muV", "1f Harmonic R and Q, \muV", ...
                   "2f Harmonic X and Y, \muV", "2f Harmonic R and Q, \muV"];
    x_label = "Frequency, MHz";

    for i = 1:length(a)
        ax = a(i);
        hold(ax, 'on');
        grid(ax, 'on');
        set(ax, 'Units', 'centimeters');
        set(ax, 'FontSize', 12, 'FontName', 'Arial');
        xlabel(ax, x_label);
        title(ax, axes_titles(i));
    end
    yyaxis(axis_dc, 'left');
    ylabel(axis_dc, 'V_0, mV');
    set(axis_dc, 'YColor', 'k');
    yyaxis(axis_dc, 'right');
    ylabel(axis_dc, 'V_2/V_0');
    set(axis_dc, 'YColor', 'b');
    %set(axis_dc, 'YTick', []);

    yyaxis(axis_kerr, 'left');
    ylabel(axis_kerr, '\theta_K, \murad');
    set(axis_kerr, 'YColor', 'k');
    yyaxis(axis_kerr, 'right');
    set(axis_kerr, 'YColor', 'k');
    set(axis_kerr, 'YTick', []);

    yyaxis(axis_x1y1, 'left');
    set(axis_x1y1, 'YColor', 'r');
    ylabel(axis_x1y1, 'X_1, \muV');
    yyaxis(axis_x1y1, 'right');
    set(axis_x1y1, 'YColor', 'b')
    ylabel(axis_x1y1, 'Y_1, \muV');

    yyaxis(axis_x2y2, 'left');
    set(axis_x2y2, 'YColor', 'r');
    ylabel(axis_x2y2, 'X_2, \muV');
    yyaxis(axis_x2y2, 'right');
    set(axis_x2y2, 'YColor', 'b');
    ylabel(axis_x2y2, 'Y_2, \muV');

    yyaxis(axis_r1q1, 'left');
    set(axis_r1q1, 'YColor', 'r');
    ylabel(axis_r1q1, 'R_1, \muV');
    yyaxis(axis_r1q1, 'right');
    set(axis_r1q1, 'YColor', 'b');
    ylabel(axis_r1q1, 'Q_1, deg');

    yyaxis(axis_r2q2, 'left');
    set(axis_r2q2, 'YColor', 'r');
    ylabel(axis_r2q2, 'R_2, \muV');
    yyaxis(axis_r2q2, 'right');
    set(axis_r2q2, 'YColor', 'b');
    ylabel(axis_r2q2, 'Q_2, deg');

end