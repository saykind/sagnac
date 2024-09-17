function animate()

    % Load table
    tab = readtable('tab80K.csv');
    filenames = tab.filename;

    %% make figure
    fig = figure('Units', 'centimeters');

    set(fig,  'Position',  [0, 0, 36, 20]);
    tl = tiledlayout(fig, 101, 2);
    axisT = nexttile(tl, [1, 2]);
    axisA = nexttile(tl, [100, 1]);
    axisB = nexttile(tl, [100, 1]);

    % Configure Temp axis
    hold(axisT, 'on');
    xlim(axisT, [0,80]);
    %xlabel(axisT,"Temperature (K)");
    set(axisT,'TickLength',[0 .01])

    a = [axisA, axisB];
    axesTitles = ["Reflectivity", "Magnetism"];
    quantities = ["P_0, a.u.", "\theta_K, \murad"];
    xylabels = ["X, \mum",      "Y, \mum";];

    for i = 1:length(a)
        ax = a(i);
        hold(ax, 'on');
        grid(ax, 'on');
        set(ax, 'Units', 'centimeters');
        set(ax, 'FontSize', 12, 'FontName', 'Arial');
        set(ax, 'DataAspectRatio', [1 1 1]);
        xlabel(ax, xylabels(1));
        ylabel(ax, xylabels(2));
        title(ax, axesTitles(i));
        cb = colorbar(ax);
        cb.Label.String = quantities(i);
        cb.Label.Rotation = 270;
        cb.Label.FontSize = 12;
        cb.Label.VerticalAlignment = "bottom";
    end
    colormap(axisA, parula);
    colormap(axisB, jet);
    set(axisA, "NextPlot", "replacechildren");
    set(axisB, "NextPlot", "replacechildren");

    v = VideoWriter("zfw_kerr_dc.avi");
    v.FrameRate = 2;
    v.Quality = 100;
    open(v)
    for i = 1:length(filenames)
        
        plot.xy.kerr(filename = filenames(i) + ".mat", ...
            ax=axisB, cutoff=60, ...
            interpolate = 8, ...
            clim = [-6,7], ...
            slope = -0.217, ...
            x0=-800, y0=330);
        plot.xy.dc(filename = filenames(i) + ".mat", ...
            ax=axisA, cutoff=60, ...
            interpolate = 8, ...
            normalize = true, ...
            clim = [0, 1], ...
            x0=-800, y0=330);
        T = round(tab.temp(i), 0);
        cla(axisT);
        plot(axisT, T, 0, 'k.', 'MarkerSize', 40);
        title(axisT, "T = " + T + " K");
        frame = getframe(fig);
        writeVideo(v,frame)
    end
    close(v)

end