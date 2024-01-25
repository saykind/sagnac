function filename = lockin_freq_2(varargin)
%Uses util.sweep() to sweep magnet current;

    %% Experiment parameters
    title = "Hall Effect";
    readme = ['Lockin A measures V_{RS} = V_{31} = V_{-x,y}\n', ...
              'Lockin B measures V_{TS} = V_{c1} = V_{yy}.'];
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
        range = [1:1:30, 32:2:140, 142:2:300];
        %range = [range, 308:8:700, 720:20:2000, 2050:50:6000];
    end
    n = numel(range);
    t0 = datetime();
    fprintf("Start: %2dh %2dm\n", t0.Hour, t0.Minute);
    fprintf("Estimated time: %.2fh \n", n*waitTime/60/60);
    t1 = t0 + seconds(n*waitTime);
    fprintf("Estimated finish: %2dh %2dm\n", t1.Hour, t1.Minute);
    
    %% Make schema
    name =      ["lockinA"; "lockinB"];
    driver =    ["SR830"; "SR830"];
    interface = ["visadev"; "visadev"];
    address =   [30; 12];
    parameters ={{'amplitude', 'phase', 'timeConstant'}; {'amplitude', 'phase', 'timeConstant'}};
    fields =    {{'f', 'X', 'Y', 'R', 'Q'}; {'X', 'Y', 'R', 'Q'}};
    schema = table(name, driver, interface, address, parameters, fields);
    try
        instruments = Drivers.make.instruments(schema);
    catch ME
        fprintf('[sweep.lockin_freq] Connection to instruments failed.');
        fprintf(ME)
    end
    disp(instruments)
    
    %% Instrument settings
    try
        instruments.lockinA.set('amplitude', 1, 'timeConstant', timeConstant, 'phase', 0);
        instruments.lockinB.set('timeConstant', timeConstant, 'phase', 0);
    catch ME
        fprintf('[sweep.lockin_freq] Instrument setting failed');
        fprintf(ME)
        return
    end
    
    info = Drivers.make.info(instruments, schema);
    info.title = title;
    info.current_resistor = current_resistor;
    info.readme = readme;
    info.parametername = "Frequency, Hz";
    info.waitTime = waitTime;

    
    %% Main loop
    
    %pause(waitTime);
    logdata = Drivers.make.datapoint(instruments, schema);
    
    
    save(filename, 'info', 'logdata');
    
    
    util.textprogressbar(' ');
    for i = 2:n
        x = range(i);
        util.textprogressbar(100*i/n);
        instruments.lockinA.set('freq', x);
        pause(waitTime);
        logdata = Drivers.make.data(logdata, instruments, schema);
        save(filename, 'info', 'logdata');
        if verbose, plt.lockin_freq_2('filename', filename, 'axes', axes); end
    end
    util.textprogressbar(' ');
    
    %{
    T = timer('Period',2,... %period
          'ExecutionMode','fixedRate',... %{singleShot,fixedRate,fixedSpacing,fixedDelay}
          'BusyMode','drop',... %{drop, error, queue}
          'TasksToExecute',5,...          
          'StartDelay',0,...
          'TimerFcn', @step, ...
          'StartFcn',@start,...
          'StopFcn',@stop,...
          'ErrorFcn',[]);
      
    start(T);
    
    function start(src, evt)
        instruments.lockinA.set('freq', range(1));
        logdata = {};
        axes = plt.lockin_freq_2('filename', filename, 'draft', 1);
    end
    
    function step(src, evt)
        i = get(src,'TasksExecuted');
        disp(i);
        x = range(i+1);
        logdata = Drivers.make.data(logdata, instruments, schema);
        save(filename, 'info', 'logdata');
        if verbose, plt.lockin_freq_2('filename', filename, 'axes', axes); end
        instruments.lockinA.set('freq', x);
    end
    %}
    
    save(filename, 'info', 'logdata');
    t1 = datetime();
    fprintf("Finish: %2dh %2dm\n", t1.Hour, t1.Minute);
    sound(sin(1:2000));
end