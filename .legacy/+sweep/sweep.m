function filename = sweep(x, varargin)
%Reads data from instruments, averages it and records it as a function of
%input parameter x.
%
% Parameters:
%   filename -- path to where data is saved.
%   parametername -- human name for parameter, e.g.
%                    Magnetic field, Oe
%   numPoints -- number of point to average
%   pauseTime -- 
%   verbose -- whether progressbar is printed.
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
    addParameter(p, 'numPoints', 4, @isnumeric);
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
        %lockin = Drivers.SR844(9);
        %voltmeter = Drivers.find_instrument(17);
        %lasercontroller = Drivers.ILX3724(15);
        %waveformgenerator = Drivers.A33220A(19);
        thermometer = Drivers.LSCI331(23);
        lockinA = Drivers.SR830(12);
        lockinB = Drivers.SR830(30);
    catch ME
        disp('[sweep.sweep] Connection to instruments failed.');
        return
    end
    
    %% Info
    info.temperature = thermometer.get('a');
    info.magnettemperature = thermometer.get('b');
    %info.laser_current = lasercontroller.read('current');
    %info.modulation_frequency = waveformgenerator.get('freq');
    %info.modulation_amplitude = waveformgenerator.get('amplitude');
    info.lockinA_ampl = lockinA.get('ampl');
    info.lockinA_freq = lockinA.get('freq');
    info.lockinA_phase = lockinA.get('phase');
    info.lockinB_freq = lockinB.get('freq');
    info.lockinB_phase = lockinB.get('phase');
    
    info.resistor = 20200;
    
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
            'sampletemperature', zeros(1,0), ...
            'magnettemperature', zeros(1,0), ...
            'transportX', zeros(1, 0), ...
            'transportY', zeros(1, 0), ...
            'transportbX', zeros(1, 0), ...
            'transportbY', zeros(1, 0), ...
            'transportX_err', zeros(1, 0), ...
            'transportY_err', zeros(1, 0), ...
            'transportbX_err', zeros(1, 0), ...
            'transportbY_err', zeros(1, 0) ...
            );
            %'dc', zeros(1,0), ...
            %'firstX', zeros(1,0), ...
            %'firstY', zeros(1,0), ...
            %'second', zeros(1,0), ...
            %'kerr', zeros(1,0), ...
            %'dc_err', zeros(1,0), ...
            %'firstX_err', zeros(1,0), ...
            %'firstY_err', zeros(1,0), ...
            %'second_err', zeros(1,0), ...
            %'kerr_err', zeros(1,0) ...
    end

    %Dummy structure
    vals = struct(...
        'sampletemperature', zeros(1, numPoints), ...
        'magnettemperature', zeros(1, numPoints), ...
        'transportX', zeros(1, numPoints), ...
        'transportY', zeros(1, numPoints), ...
        'transportbX', zeros(1, numPoints), ...
        'transportbY', zeros(1, numPoints) ...
        );
        %'dc', zeros(1, numPoints), ...
        %'firstX', zeros(1, numPoints), ...
        %'firstY', zeros(1, numPoints), ...
        %'second', zeros(1, numPoints), ...
        %'kerr', zeros(1, numPoints) ...
        

    %% Main loop
    %secondLockinSensitivity = .1;
    %fprintf("Analog lock-in sensitivity: %.2f", secondLockinSensitivity);
    Utilities.textprogressbar(sprintf('x=%.2f: ', x), 0);
    for i = 1:numPoints
        Utilities.textprogressbar(100*i/numPoints);

        vals.sampletemperature(i) = thermometer.get('a');
        vals.magnettemperature(i) = thermometer.get('b');
        vals.transportX(i) = lockinA.get('X');
        vals.transportY(i) = lockinA.get('Y');
        vals.transportbX(i) = lockinB.get('X');
        vals.transportbY(i) = lockinB.get('Y');
        %vals.dc(i) = str2double(query(voltmeter, 'FETC?'));
        %vals.firstX(i) = 1e6*lockin.get('X');
        %vals.firstY(i) = 1e6*lockin.get('Y');
        %vals.second(i) = lockin.get('AUX1')*secondLockinSensitivity;
        %vals.kerr(i) = Sagnatron.calculate_kerr(vals.firstX(i), vals.second(i));

        pause(pauseTime);
    end
    Utilities.textprogressbar(' ');

    %% Conclusion
    logdata.parameter(end+1) = x;
    logdata.sampletemperature(end+1) = mean(vals.sampletemperature);
    logdata.magnettemperature(end+1) = mean(vals.magnettemperature);
    logdata.transportX(end+1) = mean(vals.transportX);
    logdata.transportY(end+1) = mean(vals.transportY);
    logdata.transportbX(end+1) = mean(vals.transportbX);
    logdata.transportbY(end+1) = mean(vals.transportbY);
    logdata.transportX_err(end+1) = std(vals.transportX)/sqrt(numPoints);
    logdata.transportY_err(end+1) = std(vals.transportY)/sqrt(numPoints);
    logdata.transportbX_err(end+1) = std(vals.transportbX)/sqrt(numPoints);
    logdata.transportbY_err(end+1) = std(vals.transportbY)/sqrt(numPoints);
    %logdata.dc(end+1) = mean(vals.dc);
    %logdata.dc_err(end+1) = std(vals.dc)/sqrt(numPoints);
    %logdata.firstX(end+1) = mean(vals.firstX);
    %logdata.firstX_err(end+1) = std(vals.firstX)/sqrt(numPoints);
    %logdata.firstY(end+1) = mean(vals.firstY);
    %logdata.firstY_err(end+1) = std(vals.firstY)/sqrt(numPoints);
    %logdata.second(end+1) = mean(vals.second);
    %logdata.second_err(end+1) = std(vals.second)/sqrt(numPoints);
    %logdata.kerr(end+1) = mean(vals.kerr);
    %logdata.kerr_err(end+1) = std(vals.kerr)/sqrt(numPoints);

    save(filename, 'info', 'logdata');
    if verbose
        sound(sin(1:2000));
    end

end