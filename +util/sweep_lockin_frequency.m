function logdata = sweep_lockin_frequency(freq, varargin)
    %Sweep SR830 frequency and record data
    %
    %   Usage example:
    %   frequency = startFreq:stepFreq:stopFreq;
    %   logdata = obj.sweep_pm(frequency);
    
    % Connect instrument
    lockin = Drivers.SR830(30);
    
    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'numPoints', 20, @isnumeric);
    addParameter(p, 'pauseTime', 1, @isnumeric);
    addParameter(p, 'waitTime', 10, @isnumeric);

    parse(p, varargin{:});
    parameters = p.Results;
    
    numPoints = parameters.numPoints;
    pauseTime = parameters.pauseTime;
    waitTime = parameters.waitTime;
    
    % Array size
    n = numel(freq);
    
    % Savefile path
    date = datestr(now(), 'yyyy-mm-dd_HH-MM');
    path = fullfile(pwd(), "sweep_data/freq_sweep_" + date + ".mat");
    
    % Finishing time estimation
    estTime = n*(waitTime+numPoints*pauseTime+.5);
    start = datestr(now(), 'mmm-dd, HH-MM-ss');
    finish = datestr(now()+seconds(estTime), 'mmm-dd, HH-MM-ss');
    disp(['Start:  ', start]);
    disp(['Finish: ', finish]);
    
    % Save initial instrument parameteres
    f0 = lockin.read('frequency');
    
    % fields = lockin.fields;
    fields = {'X', 'Y', 'R', 'Q'};
    
    % Main data structure
    logdata.frequency = freq;
    for field = fields
        logdata.(field{:}) = zeros(1, n);
        logdata.([field{:},'_err']) = zeros(1, n);
        values.(field{:}) = zeros(1, numPoints);
    end
    
    % Main loop
    Utilities.textprogressbar('Frequency sweep: ');
    for i = 1:n
        Utilities.textprogressbar(100*(i-1)/n);

        % Set frequency and amplitude of phase modulation
        f = freq(i);

        lockin.set('frequency', f);
        pause(waitTime);

        % Data measurement
        for k = 1:numPoints
            pause(pauseTime);
            for field = fields
                values.(field{:})(k) = lockin.read(field{:});
            end
        end
        % Data recording
        for field = fields
            logdata.(field{:})(i) = mean(values.(field{:}));
            err = std(values.(field{:}))/sqrt(numPoints);
            logdata.([field{:}, '_err'])(i) = err;
        end
        save(path, '-struct', 'logdata');
    end
    Utilities.textprogressbar(' ');
    
    % Set saved parameteres
    lockin.set('frequency', f0);
    
    % Finished string
    finish = datestr(now(), 'mmm-dd, HH-MM-ss');
    disp(['Finish: ', finish]);
    
end