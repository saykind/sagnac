function filename = sweep_magnet(varargin)
%Uses util.sweep() to sweep laser current;

    
    %% Acquire parameters
    p = inputParser;
    
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'waitTime', 5, @isnumeric);
    addParameter(p, 'range', 0:20:500, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    waitTime = parameters.waitTime;
    range = parameters.range;
    
    if isempty(filename)
        filename = util.filename('data\sweep\');
    end
    
    magnetpowersupply = Drivers.KEPCO(5);

    magnetpowersupply.set('output', 'on');
    for x = range
        magnetpowersupply.set('I', x*0.002);
        pause(waitTime);
        util.sweep(x, 'filename', filename, 'verbose', 0, 'parametername', 'Magnetic field, Oe');
    end
    magnetpowersupply.set('output', 'off');
    
    sound(sin(1:2000));
end