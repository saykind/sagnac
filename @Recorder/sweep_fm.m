function logdata = sweep_fm(obj, frequency, amplitude, numPoints, pauseTime)
    %Sweep frequency modulation amplitude and frequency
    %
    %   Usage example:
    %   frequency = startFreq:stepFreq:stopFreq;
    %   amplitude = startAmp:stepAmp:stopAmp;
    %   sweepData = obj.sweep_fm(frequency, amplitude);
    
    if nargin < 5
        pauseTime = .2;
    end
    
    if nargin < 4
        numPoints = 5;
    end
    
    [freq, amp] = meshgrid(frequency, amplitude);
    [n, m] = size(freq);
    
    % Instruments
    generator = obj.instrumentStructure.A33220A;
    lockin = obj.instrumentStructure.SR844;
    
    % Save parameteres
    [f0, a0] = generator.read('frequency', 'amplitude');
    
    % Main data structure
    logdata.frequency = freq;
    logdata.amplitude = amp;
    for field = lockin.fields
        logdata.(field{:}) = zeros(n, m);
    end
    
    % Main loop
    textprogressbar('Frequency sweep: ');
    for i = 1:n
        for j0 = 1:m
            textprogressbar(100*((i-1)*m+j0)/n/m);
            
            % Loop over 2D array in snake manner
            if mod(i,2)
                j = j0;
            else
                j = m+1-j0;
            end
            
            f = freq(i,j);
            a = amp(i,j);
            
            %fprintf("Frequency = %f,\t Amplitude = %f\r", f, a);
            generator.set('frequency', f, 'amplitude', a);
            pause(2);
            for field = lockin.fields
                value = 0;
                for k = 1:numPoints
                    value = value + lockin.read(field{:});
                    pause(pauseTime);
                end
                logdata.(field{:})(i, j) = value/numPoints;
            end
        end
    end
    textprogressbar(' ');
    
    % Set saved parameteres
    generator.set('frequency', f0, 'amplitude', a0);
    
    date = datestr(now(), 'yyyy-mm-dd_HH-MM');
    path = fullfile(pwd(), "fmsweep_" + date + ".mat");
    save(path, '-struct', 'logdata');
    
end