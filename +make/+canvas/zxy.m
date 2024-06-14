function graphics = zxy()
%Graphics initialization function.

    f = figure('Units', 'centimeters');

    set(f,  'Position',  [0, 0, 36, 18]);
    tl = tiledlayout(f, 1, 2);

    axisA = nexttile(tl);
    axisB = nexttile(tl);

    a = [axisA, axisB];
    axesTitles = ["DC power P_0, mV", "1\omega In-Phase, \muV"];
    quantities = ["P_0, mV", "10^6 X_{1\omega}/P_0"];
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
    colormap(axisB, cool);

    graphics = struct('figure', f, 'axes', a);

end