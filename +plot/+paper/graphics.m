function [fig, axs] = graphics(options)
%GRAPHICS Create a figure and axis for APS journal.
% Guidelines: https://journals.aps.org/authors/web-submission-guidelines-physical-review
% Figure width: 8.5 cm for one--column figure (probably 17.8 cm for two--column figure)


arguments
    options.units string = 'centimeters';
    options.position double {mustBeNumeric} = [1 2 8.6 7.6];
    options.subplots double {mustBeNumeric} = [1, 1];
    options.TileSpacing string = 'tight';
    options.Padding string = 'compact';
    options.fontsize double {mustBeNumeric} = 10;
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
    options.remove_yticks logical = true;
end

    % Determine figure height based on number of subplots unless position(4) is specified
    if options.position(4) == 7.6
        if isempty(options.title)
            options.position(4) = 1.2 + 3.2*options.subplots(1);
        else
            options.position(4) = 1.7 + 3.2*options.subplots(1);
        end
    end

    % Determine figure length based on number of subplots unless position(3) is specified
    if options.position(3) == 8.6
        options.position(3) = 1.2 + 7.4*options.subplots(2);
    end

    % Create figure
    fig = figure();
    set(fig, 'Units', options.units);
    % Position on screen: [from_left, from_bottom, width, height] in units
    set(fig, 'Position', options.position);     
    if ~isempty(options.title)
        set(fig, 'Name', options.title);
    end

    % Create axes
    tl = tiledlayout(options.subplots(1), options.subplots(2), ...
        "TileSpacing", options.TileSpacing, "Padding", options.Padding);
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

    % Remove xtics for all but the bottom plot
    if options.single_xticks
        for i = 1:options.subplots(1)-1
            for j = 1:options.subplots(2)
                set(axs(i, j) ,'xticklabel', {});
            end
        end
    end

    if options.remove_yticks
        % Remove ytics for all but the left plot
        if options.single_yticks
            for i = 1:options.subplots(1)
                for j = 2:options.subplots(2)
                    set(axs(i, j) ,'yticklabel', {});
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
