function filename = hall(varargin)
%Uses util.sweep() to sweep magnet current;

    %% Experiment parameters
    title = "Hall effect in GaAs";
    current_resistor = 1e6;
    
    %% Acquire parameters
    p = inputParser;
    
    addParameter(p, 'filename', util.filename('data\sweep\'), @ischar);
    addParameter(p, 'waitTime', 30, @isnumeric);
    addParameter(p, 'timeConstant', 3, @isnumeric);
    addParameter(p, 'amplitude', .1, @isnumeric);
    addParameter(p, 'step', 0.16, @isnumeric);
    addParameter(p, 'verbose', 1, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    waitTime = parameters.waitTime;
    timeConstant = parameters.timeConstant;
    amplitude = parameters.amplitude;
    step = parameters.step;
    verbose = parameters.verbose;
    
    %% Make schema
    name =      ["lockinA"; "lockinB";  "tempcont"; "magnet"];
    driver =    ["SR830";   "SR830";    "LSCI331";  "KEPCO"];
    interface = ["visadev"; "visadev";  "visa";     "visadev"];
    address =   [30;        12;         23;         5];
    parameters ={{}; {}; {}; {}};
    fields =    {{'X', 'Y', 'R', 'Q'}; ...
                 {'X', 'Y', 'R', 'Q'}; ...
                 {'A', 'B'}; ...
                 {'I', 'V'}};
    schema = table(name, driver, interface, address, parameters, fields);
    try
        instruments = Drivers.make.instruments(schema);
    catch ME
        disp('[sweep.hall] Connection to instruments failed.');
    end
    
    %% Instrument settings
    instruments.lockinA.set('amplitude', 1, 'timeConstant', timeConstant, 'phase', 0);
    instruments.lockinB.set('timeConstant', timeConstant, 'phase', 0);
    
    info = Drivers.make.info(instruments, schema);
    info.current_resistor = current_resistor;
    info.parametername = "Magnet current, A";
    info.waitTime = waitTime;
    info.title = title;
    
    logdata = {};
    [fig, axes] = plt.hall_graphics(title, info.parametername);

    %% Main loop
    instruments.magnet.set('I', 0);
    instruments.magnet.set('output', 'on');
    input("Magnet needs to be in NEGATIVE polarity. Press return to continue.", "s");
    
    range = [0:(-step):(-amplitude), (-amplitude):step:0];
    for x = range
        magnet.set('I', abs(x));
        pause(waitTime);
        logdata = Drivers.make.data(logdata, instruments, schema);
        save(filename, 'info', 'logdata');
        if verbose
            plt.hall('filename', filename, 'fig', fig, 'axes', axes); 
        end
    end

    sound(sin(1:2000));
    magnet.set('I', 0);
    input("Have you flipped the polarity of the magnet? (negative --> positive)", "s");
    
    range = [step:step:amplitude, amplitude:(-step):0];
    for x = range
        magnet.set('I', abs(x));
        pause(waitTime);
        logdata = Drivers.make.data(logdata, instruments, schema);
        save(filename, 'info', 'logdata');
        if verbose
            plt.hall('filename', filename, 'fig', fig, 'axes', axes); 
        end
    end
    
    magnet.set('I', 0);
    magnet.set('output', 'off');
    
    sound(sin(1:2000));
end