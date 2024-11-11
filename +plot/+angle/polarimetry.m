function [fig, ax] = polarimetry(options)
%POLARIMETRY polarimetry data and calculate fit parameters.
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
%
%   This code is based on tutorial from thorlabs:
%   https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=14062#VideoPolarimeterStokes
%
%   See also util.polarimetry.plot();

    arguments
        options.filenames string = [];
        options.ax = [];
        options.scale double {mustBeNumeric} = 1;
        options.xlim double {mustBeNumeric} = NaN;
        options.ylim double {mustBeNumeric} = NaN;
        options.show_legend logical = false;
        options.legends string = [];
        options.save logical = true;
        options.verbose logical = false;
        options.polarizer_orientation logical = true;    % true for vertical, false for horizontal
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
            xlabel = "QWP angle (deg)" ...
            );
    else
        fig = get(ax, 'Parent');
    end

    for i = 1:numel(filenames)
        filename = filenames(i);
        [~, name, ~] = fileparts(filename);
        logdata = load(filename).logdata;
        
        % Extract data
        angle = logdata.waveplate.angle;
        vx = logdata.lockin.auxin0;
        vy = logdata.lockin.auxin1;

        % Scale data
        vx = vx*options.scale;
        vy = vy*options.scale;

        % Coarse-grain
        sweep = struct('rate', 20, 'pause', 0);
        [angle, Vx, Vy] = util.coarse.sweep(sweep, angle, vx, vy);

        for j = 1:2
            if j == 1
                sgn = 1;
                power = Vx;
                yyaxis(ax, 'left');
                col = 'r';
            else
                sgn = -1;
                power = Vy;
                yyaxis(ax, 'right');
                col = 'b';
            end
            
            plot(ax, angle, power, '.', 'MarkerSize', 10, 'Color', col, 'DisplayName', sprintf('P_{%d}', j));

            % Stokes parameters extracted from measurement
            N = numel(angle);
            A = 2/N*sum(power);
            B = 4/N*sum(power.*sind(2*angle));
            C = 4/N*sum(power.*cosd(4*angle));
            D = 4/N*sum(power.*sind(4*angle));

            % Fit using lsqcurvefit
            x0 = [A, B, C, D];
            F = @(x, angle) 0.5*(x(1) + x(2)*sind(2*angle) + x(3)*cosd(4*angle) + x(4)*sind(4*angle));
            x = lsqcurvefit(F, x0, angle, power, [], [], optimset('Display', 'off'));
            A = x(1);
            B = x(2);
            C = x(3);
            D = x(4);

            % Plot model fit
            angle_model = min(angle):1:max(angle);
            power_model = 0.5*(A+B*sind(2*angle_model) + C*cosd(4*angle_model) + D*sind(4*angle_model));
            plot(angle_model, power_model, '--', 'LineWidth', 1, 'Color', col);

            % Display Stokes parameters
            S = [A-C, sgn*2*C, sgn*2*D, sgn*B];
            fprintf(" S0 = %6.3f V.\n S1 = %6.3f V.\n S2 = %6.3f V.\n S3 = %6.3f V.\n", S(1), S(2), S(3), S(4));
            S1 = sqrt(S(2)^2 + S(3)^2 + S(4)^2);        % Intensity of polarized light
            DOP = S1/S(1);                              % Degree of polarization
            DOLP = (S(2)^2 + S(3)^2)/S1^2;              % Degree of linear polarization
            DOCP = (S(4)/S1)^2;                         % Degree of circular polarization   
            fprintf(" Degree of Polarization           = %.1f %% \n\n", 100*DOP);
            
            % Extract polarization parameters
            fprintf(" Polarized part of light:\n");
            fprintf(" intensity of polarized light = %.3f V\n", S1);
            fprintf(" intensity of all light = %.3f V\n", S(1));
            fprintf(" Degree of Linear Polarization    = %4.2f %% \n", 100*DOLP);
            fprintf(" Degree of Circular Polarization  = %4.2f %% \n\n", 100*DOCP);

            % Extract Jones vector
            Ex = sqrt(0.5*(S1 + S(2)));
            Ey = sqrt(0.5*(S1 - S(2)));
            ph = 0.5*atan2d(S(4), S(3));
            
            % fprintf(" intensity of polarized light = %.0f uW\n", S1);
            fprintf(" |Ex| = %8.4f sqrt(V)\n", Ex);
            fprintf(" |Ey| = %8.4f sqrt(V)\n", Ey);
            fprintf(" ph_x - ph_y = %.0f deg\n", ph);

            psi = 0.5*atan2d(S(3), S(2));                   % Major axis of polarization ellipse
            chi = 0.5*atan2d(S(4), sqrt(S(2)^2 + S(3)^2));  % Ellipticity
            fprintf(" Major axis angle (psi) = %.0f deg\n", psi);
            fprintf(" Ellipticity (chi) = %.0f deg\n", chi);
        end
    end

    % Format plot
    yyaxis(ax, 'left');
    ax.YAxis(1).Color = 'r';
    ylabel(ax, 'P_{x} (V)');
    if ~isnan(options.ylim), ylim(options.ylim); end

    yyaxis(ax, 'right');
    ax.YAxis(2).Color = 'b';
    ylabel(ax, 'P_{y} (V)');
    if ~isnan(options.ylim), ylim(options.ylim); end    

    if ~isnan(options.xlim), xlim(options.xlim); end
    if options.show_legend, l = legend(ax, 'Location', 'best'); set(l, 'Interpreter', 'none'); end
    if ~isempty(legends), legend(ax, legends, 'Location', 'best'); end
    set(ax, 'Clipping', 'off');


    % Save figure
    if options.save
        [~, name, ~] = fileparts(filenames(1));
        save_filename = fullfile('output', strcat(name, '_angle.png'));
        if options.verbose, fprintf('Saving figure to %s\n', save_filename); end
        saveas(fig, save_filename, 'png');
    end
    