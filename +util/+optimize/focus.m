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
    options.range (1,2) double = [-0.16, 0.16];   % Initial range of Z position to sweep
    options.step (1,1) double = 0.02;           % Initial step size for sweeping
    options.timeout (1,1) double = 16;         % Stop after this many steps even if not converged
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
    logger = timer('ExecutionMode', 'fixedRate', ...
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
                             'signalHistory', [], ...
                             'positionHistory', [], ...
                             'timeHistory', [], ...
                             'datetimeHistory', datetime.empty(0,1), ...
                             'optimalPosition', NaN, ...
                             'instr', instr, ...
                             'axs', axs, ...
                             'fig', fig, ...
                             'options', options);

    % Start timer
    start(logger);


end

function logStart(logger, event)
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

function logStop(logger, event)
    % Log stop of the measurement
    instr = logger.UserData.instr;
    options = logger.UserData.options;
    if options.verbose
        util.msg('Focus measurement completed.');
    end
    
    % move to the optimal position if found
    if ~isnan(logger.UserData.optimalPosition)
        move(instr, logger.UserData.optimalPosition, 60e3);
        util.msg(['Optimal position moved to: ', num2str(logger.UserData.optimalPosition), ' mm']);
    else
        util.msg('No optimal position found during measurement.');
    end
end

function logStep(logger, event)
    % Log each step of the measurement
    instr = logger.UserData.instr;
    options = logger.UserData.options;
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
        plot(axs(1), logger.UserData.positionHistory, logger.UserData.signalHistory, '-o');
        plot(axs(2), logger.UserData.datetimeHistory, logger.UserData.positionHistory, '-o');
    end
    
    % Fit a parabola to the data
    if length(logger.UserData.signalHistory) > 4
        p = polyfit(logger.UserData.positionHistory, logger.UserData.signalHistory, 2);
        x_fit = linspace(min(logger.UserData.positionHistory), max(logger.UserData.positionHistory), 100);
        y_fit = polyval(p, x_fit);

        if isvalid(logger.UserData.fig) && isvalid(axs(1))
            plot(axs(1), x_fit, y_fit, 'r--', 'DisplayName', 'Parabola Fit');
        end
        
        % Find maximum point of the parabola
        vertex_x = -p(2)/(2*p(1));
        vertex_y = polyval(p, vertex_x);

        % Record optimal position into UserData
        logger.UserData.optimalPosition = vertex_x;
        if options.verbose
            util.msg(['Optimal position found: ', num2str(vertex_x), ' mm with signal: ', num2str(vertex_y)]);
        end
    end

    % move to the next position
    nextPosition = currentPosition + options.step;
    move(instr, nextPosition, 60e3); % Move to the next position
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

