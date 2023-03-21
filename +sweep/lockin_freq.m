function filename = lockin_freq(varargin)
%Uses util.sweep() to sweep magnet current;

    %% Experiment parameters
    title = "Ra3, TC=3, Power Outlet test";
    current_resistor = 1e6;
    
    
    %% Acquire parameters
    p = inputParser;
    
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'waitTime', 30, @isnumeric);
    addParameter(p, 'timeConstant', 3, @isnumeric);
    addParameter(p, 'range', [], @isnumeric);
    addParameter(p, 'verbose', 1, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    waitTime = parameters.waitTime;
    timeConstant = parameters.timeConstant;
    range = parameters.range;
    verbose = parameters.verbose;
    
    if isempty(filename)
        filename = util.filename('data\sweep\');
    end
    if isempty(range)
        range = [1:.5:30, 31:1:140, 142:2:200, 205:5:400, 410:10:800, ...
            825:25:1000, 1050:50:5000];
    end
    n = numel(range);
    t0 = datetime();
    factor = 1.3;
    fprintf("Start: %2dh %2dm\n", t0.Hour, t0.Minute);
    fprintf("Estimated time: %.2fh \n", factor*n*waitTime/60/60);
    t1 = t0 + seconds(factor*n*waitTime);
    fprintf("Estimated finish: %2dh %2dm\n", t1.Hour, t1.Minute);
    
    %% Make schema
    name =      "lockin";
    driver =    "SR830";
    interface = "visadev";
    address =   12;
    parameters ={{'amplitude', 'timeConstant'}};
    fields =    {{'f', 'X', 'Y', 'R', 'Q'}};
    schema = table(name, driver, interface, address, parameters, fields);
    try
        instruments = Drivers.make.instruments(schema);
    catch ME
        disp('[sweep.lockin_freq] Connection to instruments failed.');
    end
    
    info = Drivers.make.info(instruments, schema);
    info.title = title;
    info.current_resistor = current_resistor;
    info.parametername = "Frequency, Hz";
    info.waitTime = waitTime;

    %% Instrument settings
    instruments.lockin.set('amplitude', 1, 'timeConstant', timeConstant, 'phase', 0);

    %% Main loop
    instruments.lockin.set('freq', range(1));
    logdata = Drivers.make.datapoint(instruments, schema);
    
    save(filename, 'info', 'logdata');
    axes = plt.lockin_freq('filename', filename, 'draft', 1);
    
    util.textprogressbar(' ');
    for i = 2:n
        x = range(i);
        util.textprogressbar(100*i/n);
        instruments.lockin.set('freq', x);
        pause(waitTime);
        logdata = Drivers.make.data(logdata, instruments, schema);
        save(filename, 'info', 'logdata');
        if verbose, plt.lockin_freq('filename', filename, 'axes', axes); end
    end
    util.textprogressbar(' ');
    
    save(filename, 'info', 'logdata');
    t1 = datetime();
    fprintf("Finish: %2dh %2dm\n", t1.Hour, t1.Minute);
    sound(sin(1:2000));
end