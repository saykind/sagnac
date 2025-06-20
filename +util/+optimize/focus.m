function focus(instr, options)
% Given instrument controlling vertical position of the lense, 
% adjust position to maximize the signal.
% Assumes functions move(instr, position) and measure(instr) are defined.
%
% Create a timer to sweep the position and measure 
% the signal, plot it and fit a parabola in real time.

arguments
    instr (1,1) struct;                         % Instrument structure with fields: Z, lockin
    options.rate (1,1) double = .5;              % Measurement rate in Hz
    options.range (1,2) double = [-0.32, 0.32];   % Initial range of Z position to sweep
    options.step (1,1) double = 0.08;           % Initial step size for sweeping
    options.timeout (1,1) double = 32;         % Stop after this many steps even if not converged
    options.verbose (1,1) logical = false;          % Print messages to console
end

    % Create figure for plotting
    [fig, axs] = plot.paper.measurement( ...
        subplots = [2,1], ...
        title = 'Focus Measurement', ...
        single_xticks = false, ...
        right_yaxis = false ...
        );
    % Set axis labels
    ylabel(axs(1), 'Signal (V)');
    xlabel(axs(1), 'Z Position (mm)');    
    ylabel(axs(2), 'Z Position (mm)');    


    % Create timer
    logger = timer('ExecutionMode', 'fixedSpacing', ...
            'Period', 1/options.rate, ...
            'StartDelay', 3, ...
            'StartFcn', @logStart, ...
            'StopFcn', @logStop, ...
            'TimerFcn', @logStep, ...
            'TasksToExecute', options.timeout, ... 
            'BusyMode', 'queue', ...
            'ErrorFcn', @(~,~) util.msg('Error in timer execution.') ...
            );


    logger.UserData = struct( ...
                             'startTime', tic, ...
                             'currentStep', options.step, ...
                             'currentRange', options.range, ...
                             'signalHistory', [], ...
                             'positionHistory', [], ...
                             'timeHistory', [], ...
                             'datetimeHistory', datetime.empty(0,1), ...
                             'fitParams', [], ...
                             'optimalPosition', pos(instr), ...
                             'instr', instr, ...
                             'axs', axs, ...
                             'fig', fig, ...
                             'fit_plot_flag', false, ...
                             'options', options);
    logger.UserData.fitParams = [1, logger.UserData.optimalPosition, options.step];

    % Start timer
    start(logger);


end

function logStart(logger, ~)
    % Log start of the measurement
    instr = logger.UserData.instr;  
    options = logger.UserData.options;

    if options.verbose
        util.msg('Starting focus measurement...');
    end

    initialPosition = instr.Z.get('position') + options.range(1);
    move(instr, initialPosition, 60e3); % Move to initial position
    if options.verbose
        util.msg(['Initial position set to: ', num2str(initialPosition), ' mm']);
    end
end

function logStop(logger, ~)
    % Log stop of the measurement
    instr = logger.UserData.instr;
    options = logger.UserData.options;
    if options.verbose
        util.msg('Focus measurement completed.');
    end
    
    % move to the optimal position if found
    if ~isnan(logger.UserData.optimalPosition)
        move(instr, logger.UserData.optimalPosition, 60e3);
        util.msg(['Optimal position found: ', num2str(logger.UserData.optimalPosition), ' mm']);
    else
        util.msg('No optimal position found during measurement.');
    end
end

function logStep(logger, ~)
    % Log each step of the measurement
    instr = logger.UserData.instr;
    options = logger.UserData.options;
    step = logger.UserData.currentStep;
    range = logger.UserData.currentRange;
    optimalPosition = logger.UserData.optimalPosition;
    positions = linspace(optimalPosition + range(1), ...
                        optimalPosition + range(2), ...
                        round((range(2) - range(1)) / step));
    counter = logger.TasksExecuted;
    axs = logger.UserData.axs;

    elapsedTime = toc(logger.UserData.startTime);

    % Get current position and signal
    currentPosition = pos(instr);
    signal = measure(instr);

    % Update history
    logger.UserData.signalHistory(end+1) = signal;
    logger.UserData.positionHistory(end+1) = currentPosition;
    logger.UserData.timeHistory(end+1) = elapsedTime;
    logger.UserData.datetimeHistory(end+1) = datetime('now');

    % Clear axes
    cla(axs(1));
    cla(axs(2));

    % Plot the signal if figure is still open
    if isvalid(logger.UserData.fig) && isvalid(axs(1)) && isvalid(axs(2))
        plot(axs(1), logger.UserData.positionHistory, logger.UserData.signalHistory, 'o');
        plot(axs(2), logger.UserData.datetimeHistory, logger.UserData.positionHistory, '-o');
    end
    
    % Fit a parabola to the data
    if rem(counter,length(positions)) == 0 && length(logger.UserData.positionHistory) > 4
        % Least squares fit to a gaussian function 
        fun = @(p, x) p(1) * exp(-(x-p(2)).^2/p(3));
        p0 = logger.UserData.fitParams; % Initial guess for parameters
        xdata = logger.UserData.positionHistory;
        ydata = logger.UserData.signalHistory;
        
        opts = optimset('Display','off');
        p = lsqcurvefit(fun,p0,xdata,ydata,[],[],opts);
        logger.UserData.fitParams = p; % Update fit parameters in UserData
        if options.verbose
            util.msg(['Fitted parameters: ', num2str(p)]);
        end

        x_fit_min = min(logger.UserData.positionHistory);
        x_fit_max = max(logger.UserData.positionHistory);
        x_fit = linspace(x_fit_min, x_fit_max, 100); % Generate points for fitting curve
        y_fit = fun(p, x_fit);
        
        logger.UserData.fit_plot_flag = true; % Set flag to plot fit
        
        % Find maximum point of the parabola
        vertex_x = p(2); % Vertex x-coordinate
        vertex_y = p(1); % Vertex y-coordinate (signal at vertex)

        % Record optimal position into UserData
        logger.UserData.optimalPosition = vertex_x;
        if options.verbose
            util.msg(['Optimal position found: ', num2str(vertex_x), ' mm with signal: ', num2str(vertex_y)]);
        end

        % Check if the vertex is within the position range hitory
        if vertex_x < x_fit_min || vertex_x > x_fit_max || abs(vertex_y) < 0.03
            if step > 0.5
                util.msg('Step size too large, cannot find optimal position.');
                logger.UserData.optimalPosition = NaN; % Reset optimal position
                stop(logger); % Stop if step size is too large
            end
            % Expand the range and continue sweeping
            logger.UserData.currentRange = range * 2; % Double the range
            logger.UserData.currentStep = step * 2; % Double the step size
            util.msg(['Expanding range to: ', num2str(logger.UserData.currentRange)]);
            util.msg(['Expanding step size to: ', num2str(logger.UserData.currentStep)]);
            if vertex_x > 2 && vertex_x < 23
                logger.UserData.optimalPosition = vertex_x; % Update optimal position
                util.msg(['Optimal position updated to: ', num2str(logger.UserData.optimalPosition), ' mm']);
            end
        else
            % Reduce step size for finer adjustment
            if step < 0.03
                util.msg('Stopping measurement due to small step size.');
                stop(logger); % Stop if step size is too small
            end
            logger.UserData.currentRange = range / 2;
            logger.UserData.currentStep = step / 2;
            logger.UserData.optimalPosition = vertex_x; % Update optimal position
            util.msg(['Reducing range to: ', num2str(logger.UserData.currentRange)]);
            util.msg(['Reducing step size to: ', num2str(logger.UserData.currentStep)]);
            
        end
    end

    if logger.UserData.fit_plot_flag
        fun = @(p, x) p(1) * exp(-(x-p(2)).^2/p(3));
        p0 = logger.UserData.fitParams; % Initial guess for parameters
        xdata = logger.UserData.positionHistory;
        ydata = logger.UserData.signalHistory;
        
        opts = optimset('Display','off');
        p = lsqcurvefit(fun,p0,xdata,ydata,[],[],opts);
        logger.UserData.fitParams = p; % Update fit parameters in UserData
        if options.verbose
            util.msg(['Fitted parameters: ', num2str(p)]);
        end

        x_fit_min = min(logger.UserData.positionHistory);
        x_fit_max = max(logger.UserData.positionHistory);
        x_fit = linspace(x_fit_min, x_fit_max, 100); % Generate points for fitting curve
        y_fit = fun(p, x_fit);

        plot(axs(1), x_fit, y_fit, 'r--', 'DisplayName', 'Fit');
    end

    % move to the next position
    currentPosition = pos(instr);
    nextPosition = positions(mod(counter, length(positions)) + 1);
    move(instr, nextPosition, 60e3); % Move to the next position
    if nextPosition < currentPosition
        pause(3);
    end
    if options.verbose
        util.msg(['Moved to position: ', num2str(nextPosition), ' mm']);
    end
end

function move(instr, position, timeout)
% Move the instrument to the specified position
    instr.Z.set(position=position, timeout=timeout);
end

function pos = pos(instr)
% Get the current position of the instrument
    pos = instr.Z.get('position');
end

function signal = measure(instr)
% Measure the signal from the instrument
    sample = instr.lockin.get('sample');
    auxin0 = sample.auxin0;
    signal = auxin0(1);
end

