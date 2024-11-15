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
            options.fit_power logical = false;
            options.normalize logical = false;
            options.cut_phase logical = false;
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
                subplots = [3,1], ...
                xlabel = "Modulation Amplitude (Vpk)" ...
                );
        else
            fig = get(ax, 'Parent');
        end

        % Set axis color
        for i = 1:3
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

            %% Extract data
            a = logdata.lockin.output_amplitude(:,1);
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

            x4 = 1e3*logdata.lockin.x(:,4);
            y4 = 1e3*logdata.lockin.y(:,4);
            r4 = sqrt(x4.^2 + y4.^2);
            q4 = atan2d(y4, x4);

            dc = 1e3*logdata.lockin.auxin0(:,1);

            % Normalize                    
            if options.normalize
                dc_avg = mean(dc);    
                r1 = 1e3*r1/dc_avg;
                r2 = 1e3*r2/dc_avg;
                r3 = 1e3*r3/dc_avg;
            end

            % Substract offset
            r1 = r1 - mean(r1(a < .005));
            r2 = r2 - mean(r2(a < .05));
            r3 = r3 - mean(r3(a < .15));

            %% Cut phase data
            if options.cut_phase
                a1r = a(a > 0.5);
                q1r = q1(a > 0.5);                
                a2r = a(a > 1);
                q2r = q2(a > 1);
                a3r = a(a > 1.8);
                q3r = q3(a > 1.8);
            else
                a1r = a;
                q1r = q1;
                a2r = a;
                q2r = q2;
                a3r = a;
                q3r = q3;
            end

            %% 1f
            yyaxis(ax(1), 'right');
            plot(ax(1), a1r, q1r, 'b-');
            yyaxis(ax(1), 'left');
            plot(ax(1), a, r1, 'r-');

            %% 2f
            yyaxis(ax(2), 'right');
            plot(ax(2), a2r, q2r, 'b-');
            yyaxis(ax(2), 'left');
            plot(ax(2), a, r2, 'r-');            

            %% 3f
            yyaxis(ax(3), 'right');
            plot(ax(3), a3r, q3r, 'b-');
            yyaxis(ax(3), 'left');
            plot(ax(3), a, r3, 'r-');            

            if options.fit_power
                % fit r1 to linear, set intercept to 0
                a1_ = a(a < 0.5);
                r1_ = r1(a < 0.5);
                r1_ideal = @(x, a) x(1)*a;
                x0 = 1;
                x = lsqcurvefit(r1_ideal, x0, a1_, r1_);
                r1_fit = r1_ideal(x, a);
                plot(ax(1), a, r1_fit, 'r--');
                fprintf("r1 = %.4f a\n", x(1));

                % fit q1 to constant
                q1r_avg = mean(q1r);
                q1r_ideal = @(x, a) x*ones(size(a));
                yyaxis(ax(1), 'right');
                plot(ax(1), a1r, q1r_ideal(q1r_avg, a1r), 'b--');
                fprintf("q1 = %.4f\n", q1r_avg);

                % fit r2 to quadratic
                a2_ = a(a < 1.3);
                r2_ = r2(a < 1.3);
                r2_ideal = @(x, a) x*a.^2;
                x0 = .1;
                x = lsqcurvefit(r2_ideal, x0, a2_, r2_);
                r2_fit = r2_ideal(x, a);
                plot(ax(2), a, r2_fit, 'r--');
                fprintf("r2 = %.4f a^2\n", x(1));

                % fit q2 to constant
                q2r_avg = mean(q2r);
                q2r_ideal = @(x, a) x*ones(size(a));
                yyaxis(ax(2), 'right');
                plot(ax(2), a2r, q2r_ideal(q2r_avg, a2r), 'b--');
                fprintf("q2 = %.4f\n", q2r_avg);

                % fit r3 to cubic
                a3_ = a(a < 1.5);
                r3_ = r3(a < 1.5);
                r3_ideal = @(x, a) x(1)*a.^3;
                x0 = .01;
                x = lsqcurvefit(r3_ideal, x0, a3_, r3_);
                r3_fit = r3_ideal(x, a);
                plot(ax(3), a, r3_fit, 'r--');
                fprintf("r3 = %.4f a^3\n", x(1));

                % fit q3 to constant
                q3r_avg = mean(q3r);
                q3r_ideal = @(x, a) x*ones(size(a));
                yyaxis(ax(3), 'right');
                plot(ax(3), a3r, q3r_ideal(q3r_avg, a3r), 'b--');
                fprintf("q3 = %.4f\n", q3r_avg);
            end

        end

        % Format plot
        yyaxis(ax(1), 'left');
        if options.normalize, ylabel(ax(1), '10^3 R_1/DC'); else, ylabel(ax(1), 'R_1 (mV)'); end
        yyaxis(ax(1), 'right');
        ylabel(ax(1), '\Theta_1 (deg)');
        ylim(ax(1), [-180, 180]);

        yyaxis(ax(2), 'left');
        if options.normalize, ylabel(ax(2), '10^3 R_2/DC'); else, ylabel(ax(2), 'R_2 (mV)'); end
        yyaxis(ax(2), 'right');
        ylabel(ax(2), '\Theta_2 (deg)');
        ylim(ax(2), [-180, 180]);

        yyaxis(ax(3), 'left');
        if options.normalize, ylabel(ax(3), '10^3 R_3/DC'); else, ylabel(ax(3), 'R_3 (mV)'); end
        yyaxis(ax(3), 'right');
        ylabel(ax(3), '\Theta_3 (deg)');
        ylim(ax(3), [-180, 180]);

        if ~isnan(options.ylim), ylim(options.ylim); end    
        if ~isnan(options.xlim), xlim(options.xlim); end
        
        if options.show_legend, l = legend(ax, 'Location', 'best'); set(l, 'Interpreter', 'none'); end
        if ~isempty(legends), legend(ax, legends, 'Location', 'best'); end
        set(ax, 'Clipping', 'off');
    
    
        % Save figure
        if options.save
            [~, name, ~] = fileparts(filenames(1));
            save_filename = fullfile('output', strcat(name, '_ampl.png'));
            if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
            saveas(fig, save_filename, 'png');
        end