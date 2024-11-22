function graphics = canvas()
%Graphics initialization function.

    fig = plot.paper.measurement(subplots=[0,0], title = "Frequency sweep");
    tg = uitabgroup(fig);
    tab_0f = uitab(tg, 'Title', 'DC Voltage');
    tab_1f = uitab(tg, 'Title', 'First Harm (1f)');
    tab_2f = uitab(tg, 'Title', 'Second Harm (2f)');
    tab_3f = uitab(tg, 'Title', 'Third Harm (3f)');

    %% TAB: DC 
    [~, ax_0f] = plot.paper.measurement(...
       fig = fig, ...
       tab = tab_0f, ...
       right_yaxis = false, ...
       subplots = [1,1]);

    %% TAB: 1f
    [~, ax_1f] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_1f, ...
        right_yaxis = false, ...
        subplots = [1,1]);

    %% TAB: 2f
    [~, ax_2f] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_2f, ...
        right_yaxis = false, ...
        subplots = [1,1]);    

    %% TAB: 3f
    [~, ax_3f] = plot.paper.measurement(...
        fig = fig, ...
        tab = tab_3f, ...
        right_yaxis = false, ...
        subplots = [1,1]);

    %% Epiloge
    % Set font size
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 12);

    ax = cat(1, ax_0f, ax_1f, ax_2f, ax_3f);
    graphics = struct('figure', fig, 'axes', ax);

    axesTitles = ["DC voltage P_0, mV", "First Harm P_{1\omega}, \muV", ...
        "Second Harm P_{2\omega}, mV", "Third Harm P_{3\omega}, \muV"];
    quantities = ["P_0, mV", "P_{1\omega}, \muV", ...
                  "P_{2\omega}, mV", "P_{3\omega}, \muV"];

    for i = 1:length(ax)
        ax = graphics.axes(i);
        xlabel(ax, "Frequency, MHz");
        ylabel(ax, "Amplitude, V");
        title(ax, axesTitles(i));
        cb = colorbar(ax);
        cb.Label.String = quantities(i);
        cb.Label.Rotation = 270;
        cb.Label.FontSize = 12;
        cb.Label.VerticalAlignment = "bottom";
        colormap(ax, jet);
    end

end