function fig = plot_time(logdata, fieldNames, varargin)
    % Collect data
    time = logdata.(fieldNames.time)/3600;   %time in hours
    firstX = logdata.(fieldNames.firstHarmonicX);
    firstY = logdata.(fieldNames.firstHarmonicY);
    second = logdata.(fieldNames.secondHarmonic);
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
    smooth_bin = bin*3600;
    range = parameters.range;
    
    if parameters.verbose
        fprintf("bin = %.2f K\n", bin);
        fprintf("range = [%.1f K, %.1f K]\n", range(1), range(2));
    end
    
    %   Create figure with 4 tiles
    fig = figure('Name', 'Measured data vs time');
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
        
    %   Plot of Kerr angle vs temperature
    title(ax1, 'Kerr angle');
    plot(ax1, time, kerr, '.', 'MarkerSize', .5, ...
        'Color', [.85, 0.85, 1], 'DisplayName', 'Raw data');
    plot(ax1, time, smooth(kerr, smooth_bin), 'LineWidth', 1.5, 'Color', [0, 0, .75], ...
        'DisplayName', sprintf('dt = %.2f h', bin));
    ylabel(ax1, '\theta_K (\murad)');

    %   Plot of real part of first harmonic vs temperature
    title(ax2, '(Re) First harmonic amplitude');
    plot(ax2, time, firstX, '.', 'MarkerSize', .5, ...
        'Color', [1, .85, .85], 'DisplayName', 'Raw data');
    plot(ax2, time, smooth(firstX, smooth_bin), 'LineWidth', 1.5, 'Color', [.75, 0, 0], ...
        'DisplayName', sprintf('dt = %.2f h', bin));
    ylabel(ax2, 'Re V_{1\omega} (\muV)');
    
    %   Plot of imaginary part of first harmonic vs temperature
    title(ax3, '(Im) First harmonic amplitude');
    plot(ax3, time, firstY, '.', 'MarkerSize', .5, ...
        'Color', [.6, .8, 1], 'DisplayName', 'Raw data');
    plot(ax3, time, smooth(firstY, smooth_bin), 'LineWidth', 1.5, 'Color', [0, 0, 1], ...
        'DisplayName', sprintf('dt = %.2f h', bin));
    ylabel(ax3, 'Im V_{1\omega} (\muV)');

    %   Plot of second harmonic vs temperature
    title(ax4, '(Abs) Second harmonic amplitude');
    plot(ax4, time, second, '.', 'MarkerSize', .5, ...
        'Color', [1, .85, .85], 'DisplayName', 'Raw data');
    plot(ax4, time, smooth(second, smooth_bin), 'LineWidth', 1.5, 'Color', [1, 0, 0], ...
        'DisplayName', sprintf('dt = %.2f h', bin));
    ylabel(ax4, 'V_{2\omega} (V)');
    xlabel(ax4, 'time (hours)');
end