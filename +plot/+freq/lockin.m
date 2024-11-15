function [fig, ax] = lockin(options)
    %LOCKIN plots lockin data vs modulation amplitude angle.
    %
    %   Output Arguments:
    %   - fig           : Graphics handle.
    %   - ax            : Axes handle.
    %
    %   Notes:
    %   - The function assumes that 
    %       logdata.lockin.auxin0 = power-x
    %       logdata.lockin.auxin1 = power-y
    %
    %   See also util.polarimetry.plot();
    
        arguments
            options.filenames string = [];
            options.ax = [];
            options.fit_sagnac = false;
            options.scale double {mustBeNumeric} = 1;
            options.xlim double {mustBeNumeric} = NaN;
            options.ylim double {mustBeNumeric} = NaN;
            options.show_legend logical = false;
            options.legends string = [];
            options.save logical = true;
            options.verbose logical = false;
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
                subplots = [4,1], ...
                xlabel = "Modulation Frequency (MHz)" ...
                );
        else
            fig = get(ax, 'Parent');
        end

        % Set axis color
        for i = 1:numel(ax)
            for j = 1:1
                yyaxis(ax(i, j), 'right');
                ax(i, j).YAxis(1).Color = 'r';
                ax(i, j).YAxis(2).Color = 'b';
                yyaxis(ax(i, j), 'left');
            end
        end
    
        for i = 1:numel(filenames)
            filename = filenames(i);
            data = load(filename);
            logdata = data.logdata;

            if ~isfield(logdata, 'lockin') || ~isfield(logdata.lockin, 'oscillator_frequency')
                warning('No freq sweep data found in %s', filename);
                continue;
            end

            %% Extract data
            f = 1e6*logdata.lockin.oscillator_frequency(:,1);
            x1 = 1e3*logdata.lockin.x(:,1);
            y1 = 1e3*logdata.lockin.y(:,1);
            r1 = sqrt(x1.^2 + y1.^2);
            q1 = atan2d(y1, x1);

            x2 = 1e3*logdata.lockin.x(:,2);
            y2 = 1e3*logdata.lockin.y(:,2);
            r2 = sqrt(x2.^2 + y2.^2);
            q2 = atan2d(y2, x2);

            x3 = 1e3*logdata.lockin.x(:,3);
            y3 = 1e3*logdata.lockin.y(:,3);
            r3 = sqrt(x3.^2 + y3.^2);
            q3 = atan2d(y3, x3);

            dc = 1e3*logdata.lockin.auxin0(:,1);

            %% DC
            yyaxis(ax(1), 'right');
            plot(ax(1), f, r2./dc, 'b-');
            yyaxis(ax(1), 'left');
            plot(ax(1), f, dc, 'r-');

            %% 1f
            yyaxis(ax(2), 'right');
            plot(ax(2), f, q1, 'b-');
            yyaxis(ax(2), 'left');
            plot(ax(2), f, r1, 'r-');

            %% 2f
            yyaxis(ax(3), 'right');
            plot(ax(3), f, q2, 'b-');
            yyaxis(ax(3), 'left');
            plot(ax(3), f, r2, 'r-');

            %% 3f
            yyaxis(ax(4), 'right');
            plot(ax(4), f, q3, 'b-');
            yyaxis(ax(4), 'left');
            plot(ax(4), f, r3, 'r-');

            if options.fit_sagnac
                % Fit r1 to linear, set intercept to 0
                a1_ = a(a < 0.5);
                r1_ = r1(a < 0.5);
                r1_ideal = @(x, a) x(1)*a;
                x0 = 1;
                x = lsqcurvefit(r1_ideal, x0, a1_, r1_);
                r1_fit = r1_ideal(x, a);
                plot(ax(1), a, r1_fit, 'r--');
                fprintf("r1 = %.4f a\n", x(1));
            end

        end

        % Format plot
        yyaxis(ax(1), 'left');
        ylabel(ax(1), 'DC (mV)');
        yyaxis(ax(1), 'right');
        ylabel(ax(1), 'R_2/DC');

        yyaxis(ax(2), 'left');
        ylabel(ax(2), 'R_1 (mV)');
        yyaxis(ax(2), 'right');
        ylabel(ax(2), '\Theta_1 (deg)');
        ylim(ax(2), [-180, 180]);

        yyaxis(ax(3), 'left');
        ylabel(ax(3), 'R_2 (mV)');
        yyaxis(ax(3), 'right');
        ylabel(ax(3), '\Theta_2 (deg)');
        ylim(ax(3), [-180, 180]);

        yyaxis(ax(4), 'left');
        ylabel(ax(4), 'R_3 (mV)');
        yyaxis(ax(4), 'right');
        ylabel(ax(4), '\Theta_3 (deg)');
        ylim(ax(4), [-180, 180]);

        if ~isnan(options.ylim), ylim(options.ylim); end    
        if ~isnan(options.xlim), xlim(options.xlim); end
        
        if options.show_legend, l = legend(ax, 'Location', 'best'); set(l, 'Interpreter', 'none'); end
        if ~isempty(legends), legend(ax, legends, 'Location', 'best'); end
        set(ax, 'Clipping', 'off');
    
    
        % Save figure
        if options.save
            [~, name, ~] = fileparts(filenames(1));
            save_filename = fullfile('output', strcat(name, '_freq.png'));
            if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
            saveas(fig, save_filename, 'png');
        end