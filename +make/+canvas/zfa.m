function graphics = zfa()
%Graphics initialization function.

    f = figure('Units', 'centimeters');

    set(f,  'Position',  [0, 0, 36, 18]);

    tabgroup = uitabgroup(f);
    tab_kerr = uitab(tabgroup, 'Title', 'Kerr');
    tab_x1y1 = uitab(tabgroup, 'Title', '1f Harmonic');
    tab_x2y2 = uitab(tabgroup, 'Title', '2f Harmonic');
    tab_r1r2 = uitab(tabgroup, 'Title', '1f and 2f Magnitude');

    tl_kerr = tiledlayout(tab_kerr, 1, 2);
    tl_x1y1 = tiledlayout(tab_x1y1, 1, 2);
    tl_x2y2 = tiledlayout(tab_x2y2, 1, 2);
    tl_r1r2 = tiledlayout(tab_r1r2, 1, 2);

    axis_dc = nexttile(tl_kerr);
    axis_kerr = nexttile(tl_kerr);

    axis_x1 = nexttile(tl_x1y1);
    axis_y1 = nexttile(tl_x1y1);

    axis_x2 = nexttile(tl_x2y2);
    axis_y2 = nexttile(tl_x2y2);

    axis_r1 = nexttile(tl_r1r2);
    axis_r2 = nexttile(tl_r1r2);

    a = [axis_dc, axis_kerr, ...
         axis_x1, axis_y1, ...
         axis_x2, axis_y2, ...
         axis_r1, axis_r2];

    graphics = struct('figure', f, 'axes', a);

    axes_titles = ["DC power P_0, mV", "Kerr signal \theta, \murad", ...
                   "1f Harmonic X, \muV", "1f Harmonic Y, \muV", ...
                   "2f Harmonic X, mV", "2f Harmonic Y, mV", ...
                   "1f Magnitude R_1, mV", "2f Magnitude R_2, mV"];
    quantities = ["P_0, mV", "\theta, \murad", ...
                  "X_{1\omega}, \muV", "Y_{1\omega}, \muV", ...
                  "X_{2\omega}, mV", "Y_{2\omega}, mV", ...
                  "R_{1\omega}, \muV", "R_{2\omega}, mV"];
    xylabels = ["Frequency, MHz", "Amplitude, V"];

    for i = 1:length(a)
        ax = a(i);
        hold(ax, 'on');
        grid(ax, 'on');
        set(ax, 'Units', 'centimeters');
        set(ax, 'FontSize', 12, 'FontName', 'Arial');
        xlabel(ax, xylabels(1));
        ylabel(ax, xylabels(2));
        title(ax, axes_titles(i));
        cb = colorbar(ax);
        cb.Label.String = quantities(i);
        cb.Label.Rotation = 270;
        cb.Label.FontSize = 12;
        cb.Label.VerticalAlignment = "bottom";
        if i % 2 == 0
            colormap(ax, cool);
        else
            colormap(ax, parula);
        end
    end

end