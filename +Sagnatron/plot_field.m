function [fig, phase] = plot_field(logdata, varargin)
    %Plot kerr angle versus temperature.
    
    % Collect data
    v1x = logdata.first;
    v1y = logdata.firstY;
    v2 = logdata.second;
    temp = logdata.temperature;
    field = logdata.field;
    
    % Parameter acquisition
    bin = 5;
    range = [];
    phase = 0;
    
    verbose = 0;
    showLegend = 0;
    showRefline = 0;
    
    color = [];
    fig = [];
    
    if ~isempty(varargin)
        l = length(varargin);
        i = 1;
        while i <= l
            if strcmp(varargin{i}, 'verbose')
                i = i + 1;
                verbose = varargin{i};
                i = i + 1;
                continue;
            end
            if strcmp(varargin{i}, 'phase')
                i = i + 1;
                phase = varargin{i};
                i = i + 1;
                continue;
            end
            if strcmp(varargin{i}, 'bin')
                i = i + 1;
                bin = varargin{i};
                i = i + 1;
                continue;
            end
            if strcmp(varargin{i}, 'range')
                i = i + 1;
                range = varargin{i};
                i = i + 1;
                continue;
            end
            if strcmp(varargin{i}, 'legend')
                i = i + 1;
                showLegend = varargin{i};
                i = i + 1;
                continue;
            end
            if strcmp(varargin{i}, 'figure')
                i = i + 1;
                fig = varargin{i};
                i = i + 1;
                continue;
            end
            if strcmp(varargin{i}, 'color')
                i = i + 1;
                color = varargin{i};
                i = i + 1;
                continue;
            end
            if strcmp(varargin{i}, 'refline')
                i = i + 1;
                showRefline = varargin{i};
                i = i + 1;
                continue;
            end
            fprintf("Argument #%d is not recognized.\n", i);
            i = i + 1;
        end
    end
    
    if isempty(range)
        range = [min(field), max(field)];
    end
    if isempty(color)
        color = [0, 0, .75];
    end
    if isempty(fig) || ~ishandle(fig)
        fig = figure('Name', 'Kerr angle vs Temperature');
        ax = axes(fig, 'FontSize', 14);
    else
        ax = fig.CurrentAxes;
        %cla(ax);
    end

    if verbose
        fprintf("bin = %.2f K\n", bin);
        fprintf("range = [%.1f K, %.1f K]\n", range(1), range(2));
        fprintf("phi  = %.1f deg\n", rad2deg(phase));
    end
    
    v1 = (v1x+v1y*1i)*exp(-1i*phase); 
    % sign convention for angle was inherited from databrowser
    kerr = Sagnatron.calculate_kerr(real(v1), v2);
    
    [B, K, K_err] = Sagnatron.coarse_grain(bin, field, kerr);
    
    xlim(ax, range);
    hold(ax, 'on');
    grid(ax, 'on');
    
    errorbar(ax, B, K, K_err, 'o', 'Color', color, 'DisplayName', ...
        sprintf('dB  = %.2f K\nphi = %.0f deg', bin, rad2deg(phase)));
    
    if showLegend
        legend(ax, 'show', 'AutoUpdate', 'off');
    end
    if showRefline
        hline = refline(ax, [0, 0]);
        hline.Color = 'k';
    end
    ylabel(ax, 'Kerr angle \theta_K, \murad');
    xlabel(ax, 'Magnetic field B, Gauss');
end