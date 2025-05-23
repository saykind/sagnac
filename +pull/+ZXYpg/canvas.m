function graphics = canvas()
%Graphics initialization function.

    plot_curr = true;

    f = figure('Units', 'centimeters');

    set(f,  'Position',  [0, 0, 36, 18]);
    tl = tiledlayout(f, 1, 2);

    axisA = nexttile(tl);
    axisB = nexttile(tl);

    a = [axisA, axisB];
    if plot_curr
        axesTitles = ["DC power P_0, mV", "Photogalvanic"];
        quantities = ["P_0, mV", "In-phase I_{xx}, pA"];
    else
        axesTitles = ["DC power P_0, mV", "1\omega In-Phase, \muV"];
        quantities = ["P_0, mV", "10^6 X_{1\omega}"];
    end
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

    drawnow;
    % colormap(axisA, parula);
    % colormap(axisB, jet);
    colormap(parula);

    graphics = struct('figure', f, 'axes', a);


end