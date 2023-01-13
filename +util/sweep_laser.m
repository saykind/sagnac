function filename = sweep_laser(varargin)
%Uses util.sweep() to sweep laser current;

    
    %% Acquire parameters
    p = inputParser;
    
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'waitTime', 30, @isnumeric);
    addParameter(p, 'range', 70:3:100, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    waitTime = parameters.waitTime;
    range = parameters.range;
    
    if isempty(filename)
        filename = util.filename('data\sweep\');
    end
    
    lasercontroller = Drivers.ILX3724(15);

    for x = range
        lasercontroller.set('current', x);
        pause(waitTime);
        util.sweep(x, 'filename', filename, 'verbose', 0, 'parametername', 'Laser current, mA');
    end
    
    sound(sin(1:2000));
end