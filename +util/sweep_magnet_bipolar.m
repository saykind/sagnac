function filename = sweep_magnet_bipolar(varargin)
%Uses util.sweep() to sweep laser current;

    
    %% Acquire parameters
    p = inputParser;
    
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'waitTime', 10, @isnumeric);
    addParameter(p, 'amplitude', 0.4, @isnumeric);
    addParameter(p, 'step', 0.04, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    waitTime = parameters.waitTime;
    amplitude = parameters.amplitude;
    step = parameters.step;
    
    if isempty(filename)
        filename = util.filename('data\sweep\');
    end
    
    %magnetpowersupply = Drivers.KEPCO(5);
    magnetpowersupply = Drivers.LSCI340(16);

    magnetpowersupply.set('output', 'on');
    for x = (-amplitude):step:0
        magnetpowersupply.set('I', abs(x));
        pause(waitTime);
        util.sweep(x, 'filename', filename, 'verbose', 0, 'parametername', 'Magnet current, A');
    end
    sound(sin(1:2000));
    input_result = input("Have you flipped the polarity of the magnet?", "s");
    if isempty(input_result) || input_result(1) == 'y' || input_result == 'Y'
        for x = 0:step:amplitude
            magnetpowersupply.set('I', x);
            pause(waitTime);
            util.sweep(x, 'filename', filename, 'verbose', 0, 'parametername', 'Magnet current, A');
        end
    end
    magnetpowersupply.set('I', 0);
    magnetpowersupply.set('output', 'off');
    
    sound(sin(1:2000));
end