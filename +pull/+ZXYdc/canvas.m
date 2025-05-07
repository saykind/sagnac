function graphics = canvas()
%Graphics initialization function.


    f = figure('Units', 'centimeters');

    set(f,  'Position',  [0, 0, 20, 18]);
    ax = subplot(1, 1, 1, 'Parent', f);

    axesTitles = "DC power P_0, mV";
    quantities = "P_0, mV";
    xylabels = ["X, \mum",      "Y, \mum"];

    hold(ax, 'on');
    grid(ax, 'on');

    set(ax, 'Units', 'centimeters');
    set(ax, 'FontSize', 12, 'FontName', 'Arial');
    set(ax, 'DataAspectRatio', [1 1 1]);

    xlabel(ax, xylabels(1));
    ylabel(ax, xylabels(2));
    title(ax, axesTitles);

    cb = colorbar(ax);
    cb.Label.String = quantities;
    cb.Label.Rotation = 270;
    cb.Label.FontSize = 12;
    cb.Label.VerticalAlignment = "bottom";

    drawnow;
    colormap(parula);
    graphics = struct('figure', f, 'axes', ax);

end