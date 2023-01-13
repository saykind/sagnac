function filename = sweep(x, varargin)
%Reads data from instruments, averages it and records it as a function of
%input parameter x.
%
% Parameters:
%   filename -- path to where data is saved.
%   numPoints -- number of point to average
%   
%
% Usage example:
% util.sweep(0);
% util.sweep(5);

    %% Acquire parameters
    p = inputParser;
    
    addParameter(p, 'filename', '', @ischar);
    addParameter(p, 'parametername', 'Parameter', @ischar);
    addParameter(p, 'verbose', 1, @isnumeric);
    addParameter(p, 'numPoints', 15, @isnumeric);
    addParameter(p, 'pauseTime', 1, @isnumeric);

    parse(p, varargin{:});
    parameters = p.Results;
    
    filename = parameters.filename;
    parametername = parameters.parametername;
    verbose = parameters.verbose;
    numPoints = parameters.numPoints;
    pauseTime = parameters.pauseTime;

    %% GPIB connections
    try
        lockin = Drivers.SR844(9);
        voltmeter = Drivers.find_instrument(17);
        thermometer = Drivers.LSCI331(23);
        lasercontroller = Drivers.ILX3724(15);
        waveformgenerator = Drivers.A33220A(19);
        %FIXME Add magnet power supply
    catch
        disp('Connection to instruments failed.');
        return
    end
    
    %% Info
    info.temperature = thermometer.read('a');
    info.magnettemperature = thermometer.read('b');
    info.laser_current = lasercontroller.read('current');
    info.modulation_frequency = waveformgenerator.read('freq');
    info.modulation_amplitude = waveformgenerator.read('amplitude');
    info.lockin_phase = lockin.read('phase');
    
    info.magnetic_field = 0;
    info.parametername = parametername;
    info.numPoints = numPoints;
    info.pauseTime = pauseTime;

    %% Datafile
    if isempty(filename)
        filename = util.filename('data\sweep\');
    end
    
    %% Load/create data structure
    if exist(filename, 'file')
        logdata = load(filename, 'logdata').logdata;
    else
        logdata = struct(...
            'parameter', zeros(1,0), ...
            'dc', zeros(1,0), ...
            'firstX', zeros(1,0), ...
            'firstY', zeros(1,0), ...
            'second', zeros(1,0), ...
            'kerr', zeros(1,0), ...
            'dc_err', zeros(1,0), ...
            'firstX_err', zeros(1,0), ...
            'firstY_err', zeros(1,0), ...
            'second_err', zeros(1,0), ...
            'kerr_err', zeros(1,0) ...
            );
    end

    %Dummy structure
    vals = struct(...
        'dc', zeros(1, numPoints), ...
        'firstX', zeros(1, numPoints), ...
        'firstY', zeros(1, numPoints), ...
        'second', zeros(1, numPoints), ...
        'kerr', zeros(1, numPoints) ...
        );

    %% Main loop
    Utilities.textprogressbar(sprintf('x=%.2f: ', x), 0);
    for i = 1:numPoints
        Utilities.textprogressbar(100*i/numPoints);

        vals.dc(i) = str2double(query(voltmeter, 'FETC?'));
        vals.firstX(i) = 1e6*lockin.read('X');
        vals.firstY(i) = 1e6*lockin.read('Y');
        vals.second(i) = lockin.read('AUX1')*.25;
        vals.kerr(i) = Sagnatron.calculate_kerr(vals.firstX(i), vals.second(i));

        pause(pauseTime);
    end
    Utilities.textprogressbar(' ');

    %% Conclusion
    logdata.parameter(end+1) = x;
    logdata.dc(end+1) = mean(vals.dc);
    logdata.dc_err(end+1) = std(vals.dc)/sqrt(numPoints);
    logdata.firstX(end+1) = mean(vals.firstX);
    logdata.firstX_err(end+1) = std(vals.firstX)/sqrt(numPoints);
    logdata.firstY(end+1) = mean(vals.firstY);
    logdata.firstY_err(end+1) = std(vals.firstY)/sqrt(numPoints);
    logdata.second(end+1) = mean(vals.second);
    logdata.second_err(end+1) = std(vals.second)/sqrt(numPoints);
    logdata.kerr(end+1) = mean(vals.kerr);
    logdata.kerr_err(end+1) = std(vals.kerr)/sqrt(numPoints);

    save(filename, 'info', 'logdata');
    if verbose
        sound(sin(1:2000));
    end

end