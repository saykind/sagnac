function logdata = sweep_pm(obj, frequency, amplitude, varargin)
    %Sweep frequency modulation amplitude and frequency
    %
    %   Usage example:
    %   frequency = startFreq:stepFreq:stopFreq;
    %   amplitude = startAmp:stepAmp:stopAmp;
    %   logdata = obj.sweep_pm(frequency, amplitude);
    
    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'numPoints', 10, @isnumeric);
    addParameter(p, 'pauseTime', .2, @isnumeric);
    addParameter(p, 'waitTime', 8, @isnumeric);

    parse(p, varargin{:});
    parameters = p.Results;
    
    numPoints = parameters.numPoints;
    pauseTime = parameters.pauseTime;
    waitTime = parameters.waitTime;
    
    % Grid
    [freq, amp] = meshgrid(frequency, amplitude);
    [n, m] = size(freq);
    
    % Savefile path
    date = datestr(now(), 'yyyy-mm-dd_HH-MM');
    path = fullfile(pwd(), "pmsweep_" + date + ".mat");
    
    % Finishing time estimation
    estTime = n*m*(waitTime+numPoints*pauseTime);
    start = datestr(now(), 'mmm-dd, HH-MM-ss');
    finish = datestr(now()+seconds(estTime), 'mmm-dd, HH-MM-ss');
    disp(['Start:  ', start]);
    disp(['Finish: ', finish]);
    
    % Instruments
    generator = obj.instrumentStructure.A33220A;
    lockin = obj.instrumentStructure.SR844;
    
    % Save initial instrument parameteres
    [f0, a0] = generator.read('frequency', 'amplitude');
    
    % fields = lockin.fields;
    fields = {'X', 'Y', 'R', 'Q', 'AUX1', 'AUX2'};
    
    % Main data structure
    logdata.frequency = freq;
    logdata.amplitude = amp;
    for field = fields
        logdata.(field{:}) = zeros(n, m);
        logdata.([field{:},'_err']) = zeros(n, m);
        values.(field{:}) = zeros(1, numPoints);
    end
    
    % Main loop
    Utilities.textprogressbar('Frequency sweep: ', 0);
    for i = 1:n
        for j0 = 1:m
            Utilities.textprogressbar(100*((i-1)*m+j0)/n/m);
            
            % Loop over 2D array in snake manner
            if mod(i,2)
                j = j0;
            else
                j = m+1-j0;
            end
            
            % Set frequency and amplitude of phase modulation
            f = freq(i,j);
            a = amp(i,j);
            
            %fprintf("Frequency = %f,\t Amplitude = %f\r", f, a);
            generator.set('frequency', f, 'amplitude', a);
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
                logdata.(field{:})(i, j) = mean(values.(field{:}));
                err = std(values.(field{:}))/sqrt(numPoints);
                logdata.([field{:}, '_err'])(i, j) = err;
            end
        end
        save(path, '-struct', 'logdata');
    end
    Utilities.textprogressbar(' ');
    
    % Set saved parameteres
    generator.set('frequency', f0, 'amplitude', a0);
    
    % Finished string
    finish = datestr(now(), 'mmm-dd, HH-MM-ss');
    disp(['Finish: ', finish]);
    
end