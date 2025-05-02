function [fig, ax] = dc(options)
%DC plots dc data vs y.position
%   Fits data to error function and extracts beam spot size using kinfe edge method.
%
%   Notes:
%   - The function util.logdata.lockin() is used to extract the lock-in data.
%   - The Kerr signal is calculated using util.math.kerr().
%   - The function the util.coarse.grain() is used for coarse-graining.
%   - The figure is saved in the 'output' directory.
%
%   See also plot.data();

    arguments
        options.filenames string = [];
        options.ax = [];
        options.xlim double {mustBeNumeric} = NaN;
        options.ylim double {mustBeNumeric} = NaN;
        options.show_legend logical = false;
        options.legends string = [];
        options.save logical = true;
        options.fit logical = false;
        options.verbose logical = true;
    end

    filenames = options.filenames;
    ax = options.ax;
    legends = options.legends;
    verbose = options.verbose;


    % If no filename is given, open file browser
    if isempty(filenames)
        filenames = convertCharsToStrings(util.filename.select());
        %filenames = flip(filenames);
    end
    if isempty(filenames)
        warning('No file selected.');
        return;
    end


    % Create figure
    if isempty(ax)
        [fig, ax] = plot.paper.graphics(...
            subplots = [1,1], ...
            xlabel = "Y position (um)", ...
            ylabel = "V_{DC} (mV)" ...
            );
    else
        fig = get(ax, 'Parent');
    end

    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        logdata = load(filename).logdata;
        
        % Extract data
        y = logdata.Y.position;
        y = y - mean(y);
        y = y*1e3; % Convert to um
        v0 = 1e3*logdata.lockin.auxin0(:,1);

        % Coarse-grain
        [Y, V0] = util.coarse.sweep(logdata.sweep, y, v0);

        plot(ax, Y, V0, '.-', 'LineWidth', 1);

        % Knife edge fit, fit V0 vs Y to error function
        if options.fit
            F = @(param, y) param(1) + .5*param(2)*(1+erf((y - param(3))/param(4)));
            offset0 = V0(1); 
            scale0 = V0(end) - offset0;
            center0 = mean(Y);
            width0 = 10;
            param0 = [offset0, scale0, center0, width0]; % Initial guess for parameters [offset, scale, center, width]
            [param, resnorm, ~, exitflag, output] = lsqcurvefit(F, param0, Y, V0, [], [], optimset('Display', 'off'));
            if exitflag > 0
                % Plot fit
                y_fit = linspace(min(Y), max(Y), 100);
                v_fit = F(param, y_fit);
                plot(ax, y_fit, v_fit, 'r-', 'LineWidth', 1.5);
                if options.verbose
                    fprintf('Fit parameters for %s:\n', name);
                    fprintf('\t\t offset = %.2f mV\n', param(1));
                    fprintf('\t\t scale = %.2f mV\n', param(2));
                    fprintf('\t\t center = %.2f um\n', param(3));
                    fprintf('\t\t width = %.2f um\n\n', param(4));
                    fprintf('\t\t beam spot dia = %.2f um\n\n', 2*param(4));
                end
            else
                warning('Fit did not converge for %s', name);
            end
            % if options.verbose 
            %     fprintf('Exit flag: %d\n', exitflag);
            %     fprintf('Output: %s\n', output.message);
            % end
        end
    end

    % Format plot
    if ~isnan(options.xlim), xlim(options.xlim); end
    if ~isnan(options.ylim), ylim(options.ylim); end
    if options.show_legend, l = legend(ax, 'Location', 'best'); set(l, 'Interpreter', 'none'); end
    if ~isempty(legends), legend(ax, legends, 'Location', 'best'); end
    
    % Save figure
    if options.save
        [~, name, ~] = fileparts(filenames(1));
        save_filename = fullfile('output', strcat(name, '_z_dc.png'));
        if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
        saveas(fig, save_filename, 'png');
    end