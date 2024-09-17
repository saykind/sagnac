function animate_kerr()

    % Load table
    tab = readtable('tab.csv');
    filenames = tab.filename;
    kerr_offset = -.25;
    kerr = tab.kerr - kerr_offset;
    kerr1 = tab.kerr1 - kerr_offset;
    kerr2 = tab.kerr2 - kerr_offset;

    %% make figure
    fig = figure('Units', 'centimeters');

    set(fig,  'Position',  [0, 0, 36, 20]);
    tl = tiledlayout(fig, 101, 2);
    axisT = nexttile(tl, [6, 1]);
    axisB = nexttile(tl, [101, 1]);
    axisA = nexttile(tl, [89, 1]);

    % Configure Temp axis
    hold(axisT, 'on');
    xlim(axisT, [0, 200]);
    %xlabel(axisT,"Temperature (K)");
    set(axisT,'TickLength',[0 .01])


    a = [axisA, axisB];
    axesTitles = ["Reflectivity", "Magnetism"];
    quantities = ["P_0 (a.u.)", "\theta_K (\murad)"];
    xylabels = ["X, \mum",      "Y, \mum";];

    ax = axisA;
    hold(ax, 'on');
    grid(ax, 'on');
    set(ax, 'Units', 'centimeters');
    set(ax, 'FontSize', 12, 'FontName', 'Arial');
    xlabel(ax, "Temperature (K)");
    ylabel(ax, "\theta_K (\murad)");

    ax = axisB;
    hold(ax, 'on');
    grid(ax, 'on');
    set(ax, 'Units', 'centimeters');
    set(ax, 'FontSize', 12, 'FontName', 'Arial');
    set(ax, 'DataAspectRatio', [1 1 1]);
    xlabel(ax, xylabels(1));
    ylabel(ax, xylabels(2));
    title(ax, "Magnetism");
    cb = colorbar(ax);
    cb.Label.String = "\theta_K, \murad";
    cb.Label.Rotation = 270;
    cb.Label.FontSize = 12;
    cb.Label.VerticalAlignment = "bottom";
    colormap(axisB, jet);
    
    set(axisB, "NextPlot", "replacechildren");
    set(axisT, "NextPlot", "replacechildren");

    v = VideoWriter("zfw_kerr_dc.avi");
    v.FrameRate = 2;
    v.Quality = 100;
    open(v)
    for i = 1:length(filenames)
        
        plot.xy.kerr(filename = filenames(i) + ".mat", ...
            ax=axisB, cutoff=60, ...
            offsets = kerr_offset, ...
            interpolate = 8, ...
            clim = [-6,7], ...
            slope = -0.217, ...
            x0=-800, y0=330);
        
        cla(axisA);
        plot(axisA, tab.temp, kerr, 'k.-', 'DisplayName', 'AVG');
        plot(axisA, tab.temp, kerr2, 'r.-', 'DisplayName', 'MAX');
        plot(axisA, tab.temp, kerr1, 'b.-', 'DisplayName', 'MIN');
        h = plot(axisA, tab.temp(i), kerr(i), 'ro', 'MarkerSize', 10);
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        h = plot(axisA, tab.temp(i), kerr1(i), 'ko', 'MarkerSize', 10);
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        h = plot(axisA, tab.temp(i), kerr2(i), 'ko', 'MarkerSize', 10);
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        legend(axisA, 'Location', 'northwest');

        T = round(tab.temp(i), 0);
        title(axisB, "T = " + T + " K");

        plot(axisT, T, 0, 'k.', 'MarkerSize', 40);
        title(axisT, "T = " + T + " K");

        frame = getframe(fig);
        writeVideo(v,frame);
    end
    close(v)

end