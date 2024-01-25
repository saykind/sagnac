function fig = plot_temperature(logdata, fieldNames, varargin)
    % Collect data
    v1x = logdata.(fieldNames.firstHarmonicX);
    v1y = logdata.(fieldNames.firstHarmonicY);
    v2 = logdata.(fieldNames.secondHarmonic);
    temp = logdata.(fieldNames.temperature);
    if strcmp(fieldNames.kerr, "kerr2")
        kerr = logdata.(fieldNames.kerr)/2;
    else
        kerr = logdata.(fieldNames.kerr);
    end
    
    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'bin', .1, @isnumeric);
    addParameter(p, 'range', [-inf, inf], @isnumeric);
    addParameter(p, 'showLegend', false, @islogical);
    addParameter(p, 'verbose', false, @islogical);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    bin = parameters.bin; 
    range = parameters.range;
    
    if parameters.verbose
        fprintf("bin = %.2f K\n", bin);
        fprintf("range = [%.1f K, %.1f K]\n", range(1), range(2));
    end
    
    % Create figure with 4 tiles
    fig = figure('Name', 'Measured data vs temperature');
    layout = [4, 1];
    t = tiledlayout(fig, layout(1), layout(2)); 
    ax1 = nexttile(t); ax2 = nexttile(t); 
    ax3 = nexttile(t); ax4 = nexttile(t);
    hold(ax1,'on'); hold(ax2,'on'); 
    hold(ax3,'on'); hold(ax4,'on');
    grid(ax1,'on'); grid(ax2,'on'); 
    grid(ax3,'on'); grid(ax4,'on');
    if parameters.showLegend
        legend(ax1,'show'); legend(ax2,'show'); 
        legend(ax3,'show'); legend(ax4,'show');
    end
    xlim(ax1, range); xlim(ax2, range);
    xlim(ax3, range); xlim(ax4, range);
    
    % Coarse grain data
    [T, K, V1x, V1y, V2] = Sagnatron.coarse_grain(bin, temp, kerr, v1x, v1y, v2);

    % Plot of Kerr angle vs temperature
    title(ax1, 'Kerr angle');
    plot(ax1, temp, kerr, '.', 'MarkerSize', .5, ...
        'Color', [.85, 0.85, 1], 'DisplayName', 'Raw data');
    plot(ax1, T, K, 'LineWidth', 1.5, 'Color', [0, 0, .75], ...
        'DisplayName', sprintf('dT = %.2f K', bin));
    ylabel(ax1, '\theta_K (\murad)');

    %   Plot of real part of first harmonic vs temperature
    title(ax2, '(Re) First harmonic amplitude');
    plot(ax2, temp, v1x, '.', 'MarkerSize', .5, ...
        'Color', [1, .85, .85], 'DisplayName', 'Raw data');
    plot(ax2, T, V1x, 'LineWidth', 1.5, 'Color', [.75, 0, 0], ...
        'DisplayName', sprintf('dT = %.2f K', bin));
    ylabel(ax2, 'Re V_{1\omega} (\muV)');
    
    % Plot of imaginary part of first harmonic vs temperature
    title(ax3, '(Im) First harmonic amplitude');
    plot(ax3, temp, v1y, '.', 'MarkerSize', .5, ...
        'Color', [.6, .8, 1], 'DisplayName', 'Raw data');
    plot(ax3, T, V1y, 'LineWidth', 1.5, 'Color', [0, 0, 1], ...
        'DisplayName', sprintf('dT = %.2f K', bin));
    ylabel(ax3, 'Im V_{1\omega} (\muV)');

    % Plot of second harmonic vs temperature
    title(ax4, '(Abs) Second harmonic amplitude');
    plot(ax4, temp, v2, '.', 'MarkerSize', .5, ...
        'Color', [1, .85, .85], 'DisplayName', 'Raw data');
    plot(ax4, T, V2, 'LineWidth', 1.5, 'Color', [1, 0, 0], ...
        'DisplayName', sprintf('dT = %.2f K', bin));
    ylabel(ax4, 'V_{2\omega} (V)');
    xlabel(ax4, 'Temperature (K)');
end