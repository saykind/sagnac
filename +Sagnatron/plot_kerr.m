function [ax, phase, offset] = plot_kerr(logdata, varargin)
    %Plot kerr angle versus temperature.
    
    % Collect data
    v1x = logdata.first;
    v1y = logdata.firstY;
    v2 = logdata.second;
    temp = logdata.temperature;
    
    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'phase', 0, @isnumeric);
    addParameter(p, 'bin', .1, @isnumeric);
    addParameter(p, 'range', [-inf, inf], @isnumeric);
    addParameter(p, 'offset', 0, @isnumeric);
    addParameter(p, 'offsetRange', [-inf, inf], @isnumeric);
    addParameter(p, 'autoPhase', true, @islogical);
    addParameter(p, 'showOffset', false, @islogical);
    addParameter(p, 'showLegend', false, @islogical);
    addParameter(p, 'showRefline', true, @islogical);
    addParameter(p, 'hold', false, @islogical);
    addParameter(p, 'verbose', false, @islogical);
    addParameter(p, 'color', [0, 0, .75]);
    addParameter(p, 'axes', []);

    parse(p, varargin{:});
    parameters = p.Results;
    
    ax = parameters.axes;
    phase = parameters.phase;
    box = parameters.offsetRange;

    % Check graphics handle
    if isempty(ax) || ~isvalid(ax) || ~isgraphics(ax)
        fig = figure('Name', 'Kerr angle vs Temperature');
        ax = axes(fig, 'FontSize', 14);
    end
    if ~parameters.hold
        cla(ax);
    end
    
    % Calculate phase shift and kerr angle offset
    idx = find(temp > box(1) & temp < box(2));
    if parameters.autoPhase
        phase = Sagnatron.calculate_phase(v1x(idx), v1y(idx), v2(idx));
    end

    % Shift and coarse grain data, phase sign convention was inherited
    v1 = (v1x+v1y*1i)*exp(-1i*phase); 
    kerr = Sagnatron.calculate_kerr(real(v1), v2);
    offset = mean(kerr(idx));
    kerr = kerr - offset;
    
    % Dump parameters into the terminal
    if parameters.verbose
        fprintf("bin \t= %.2f K\n", parameters.bin);
        fprintf("range \t= [%.1f K, %.1f K]\n", parameters.range);
        fprintf("phase \t= %.2f deg\n", rad2deg(phase));
        fprintf("offset range \t= [%.1f K, %.1f K]\n", box);
        fprintf("offset value \t= %.2f microrad\n", offset);
    end
    
    % Coarse grain data
    [T, K, K_err] = Sagnatron.coarse_grain(parameters.bin, temp, kerr);

    % Add bold line y=0
    if parameters.showRefline
        range = [min(temp) max(temp)];
        plot(ax, range, [0 0], 'Color', 'k', 'LineWidth', .75);
    end
    
    % Configure the plot
    hold(ax, 'on');
    grid(ax, 'on');
    xlim(ax, parameters.range);
    ylim(ax, 'auto');
    xlabel(ax, 'Temperature T, K');
    ylabel(ax, 'Kerr angle \theta_K, \murad');
    
    % Plot the data
    errorbar(ax, T, K, K_err, 'o', 'Color', parameters.color);
    
    % Add dashed box
    if parameters.showOffset && any(box ~= [-inf, inf])
        [kerr1, kerr2] = bounds( K(T > box(1) & T < box(2)) );
        line(ax, [box(1), box(1), box(2), box(2), box(1)], ...
            1.5*[kerr1, kerr2, kerr2, kerr1, kerr1], ...
            'LineStyle', '--', 'LineWidth', 1, ...
            'Color', 'k', 'DisplayName', 'T_{offset}');
    end
    
    % Add legend
    if parameters.showLegend
        legend(ax, sprintf('dT  = %.2f K\nphi = %.0f deg', ...
            parameters.bin, rad2deg(phase)));
    end
    
    
end