function [fig, axs] = measurement(options)
%MEASURMENT creates a figure and axis for real-time data recording.

arguments
    options.figure = [];
    options.tab = [];
    options.units string = "centimeters";
    options.position double {mustBeNumeric} = [1 2 17.2 15.2];
    options.subplots double {mustBeNumeric} = [1, 1];
    options.TileSpacing string = "compact";
    options.Padding string = "compact";
    options.fontsize double {mustBeNumeric} = 12;
    options.title string = '';
    options.xlabel string = '';
    options.ylabel string = '';
    options.box logical = true;
    options.grid logical = true;
    options.hold logical = true;
    options.test logical = false;
    options.xlim double {mustBeNumeric} = [-inf, inf];
    options.ylim double {mustBeNumeric} = [-inf, inf];
    options.single_xticks logical = true;
    options.single_yticks logical = true;
    options.xticks double {mustBeNumeric} = [];
    options.yticks double {mustBeNumeric} = [];
    options.right_yaxis logical = true;
    options.color_yaxis logical = true;
end

    % Determine figure height based on number of subplots unless position(4) is specified
    if options.position(4) == 7.6
        if isempty(options.title)
            options.position(4) = 1.2 + 3.2*options.subplots(1);
        else
            options.position(4) = 1.7 + 3.2*options.subplots(1);
        end
    end

    % Create figure
    if isempty(options.figure)
        fig = figure();
        set(fig, 'Units', options.units);
        % Position on screen: [from_left, from_bottom, width, height] in units
        set(fig, 'Position', options.position);
    else
        fig = options.figure;
    end
         
    if ~isempty(options.title)
        set(fig, 'Name', options.title);
    end

    if options.subplots(1) == 0 && options.subplots(2) == 0
        axs = [];
        return
    end

    % Layout
    if isempty(options.tab)
        tl = tiledlayout(options.subplots(1), options.subplots(2), ...
            "TileSpacing", options.TileSpacing, "Padding", options.Padding);
    else
        tl = tiledlayout(options.tab, options.subplots(1), options.subplots(2), ...
            "TileSpacing", options.TileSpacing, "Padding", options.Padding);
    end

    % Create axes
    axs = gobjects(options.subplots(1), options.subplots(2));
    for i = 1:options.subplots(1)
        for j = 1:options.subplots(2)
            axs(i, j) = nexttile(tl);
        end
    end

    % Set box, grid and hold
    if options.box
        box(axs, 'on');
    else
        box(axs, 'off');
    end
    if options.grid
        grid(axs, 'on');
    else
        grid(axs, 'off');
    end
    if options.hold
        hold(axs, 'on');
    else
        hold(axs, 'off');
    end

    % Set right y-axis
    if options.right_yaxis
        for i = 1:options.subplots(1)
            for j = 1:options.subplots(2)
                yyaxis(axs(i, j), 'right');
                if options.color_yaxis
                    axs(i, j).YAxis(1).Color = 'r';
                    axs(i, j).YAxis(2).Color = 'b';
                else
                    axs(i, j).YAxis(1).Color = 'k';
                    axs(i, j).YAxis(2).Color = 'k';
                end
                yyaxis(axs(i, j), 'left');
            end
        end
    end

    % Remove xtics for all but the bottom plot
    if options.single_xticks
        for i = 1:options.subplots(1)-1
            for j = 1:options.subplots(2)
                set(axs(i, j) ,'xticklabel', {});
            end
        end
    end
    % Remove ytics for all but the left plot
    if options.single_yticks
        for i = 1:options.subplots(1)
            for j = 2:options.subplots(2)
                set(axs(i, j) ,'yticklabel', {});
            end
            if options.right_yaxis
                for j = 1:options.subplots(2)-1
                    yyaxis(axs(i, j), 'right');
                    set(axs(i, j) ,'yticklabel', {});
                    yyaxis(axs(i, j), 'left');
                end
            end
        end
    end

    % Set axis labels
    % Set x-axis label
    if ~isempty(options.xlabel)
        for j = 1:options.subplots(2)
            xlabel(axs(end, j), options.xlabel);
        end
    end
    % Set y-axis label
    if ~isempty(options.ylabel)
        for i = 1:options.subplots(1)
            ylabel(axs(i, 1), options.ylabel);
        end
    end

    % Set axis limits
    if ~any(isinf(options.xlim))
        for i = 1:options.subplots(1)
            for j = 1:options.subplots(2)
                xlim(axs(i, j), options.xlim);
            end
        end
    end
    if ~any(isinf(options.ylim))
        for i = 1:options.subplots(1)
            for j = 1:options.subplots(2)
                ylim(axs(i, j), options.ylim);
            end
        end
    end

    % Set axis ticks
    if ~isempty(options.xticks)
        for i = 1:options.subplots(1)
            for j = 1:options.subplots(2)
                xticks(axs(i, j), options.xticks);
            end
        end
    end
    if ~isempty(options.yticks)
        for i = 1:options.subplots(1)
            for j = 1:options.subplots(2)
                yticks(axs(i, j), options.yticks);
            end
        end
    end

    % Set title
    if ~isempty(options.title)
        title(axs(1, 1), options.title, 'FontWeight', 'normal');
    end

    % Set font size
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', options.fontsize);

    if options.test
        for i = 1:options.subplots(1)
            for j = 1:options.subplots(2)
                num_points = 100;
                x_data = linspace(0, 10, num_points)';
                plot(axs(i, j), x_data, sin(x_data+.25*pi*(i+j))+ .0*rand(num_points, 1));
                xticks(axs(i, j), 1:2:9);
                yticks(axs(i, j), -.5:.5:.5);
                set(axs(i, j), 'Units', 'centimeters');
                disp(axs(i, j).Position)
            end
        end
    end
