function position_sweep(x, filename)
% Reads data from SR844, averages it and records it
% Usage example:
% knife_edge(0);
% knife_edge(5);

if nargin < 1
    error('Please provide distance argument.');
end



%% Preamble

numPoints = 60;
pauseTime = 1;

% Information
info.temperature = 7;
info.magnettemperature = 4.4;
info.laserintensity = 92;
info.modulation_frequency = 4.846;
info.modulation_amplitude = 1.1;
info.lockin_phase = -61;
info.second_phase = -165.6;
info.magnetic_field = 0;
info.training_field = -2000;
info.numPoints = numPoints;
info.pauseTime = pauseTime;



% GPIB connections
lockin = Drivers.SR844(8);
second = Drivers.SR844(9);
voltmeter = Drivers.find_instrument(17);

% Datafile fetch
if nargin == 1 
    filename = 'position_sweep.mat';
end

if exist(filename, 'file')
    logdata = load(filename, 'logdata').logdata;
else
    logdata = struct(...
        'position', zeros(1,0), ...
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
quantities = fieldnames(vals);
numQuantities = length(quantities);

Utilities.textprogressbar('Collecting data: ', 0);
for i = 1:numPoints
    Utilities.textprogressbar(100*i/numPoints);
    
    vals.dc(i) = str2double(query(voltmeter, 'FETC?'));
    vals.firstX(i) = lockin.read('X');
    vals.firstY(i) = lockin.read('Y');
    vals.second(i) = second.read('X');
    vals.kerr(i) = Sagnatron.calculate_kerr(vals.firstX(i), vals.second(i));
    
    pause(pauseTime);
end
Utilities.textprogressbar(' ');

%% Conclusion
logdata.position(end+1) = x;
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

sound(sin(1:2000))

end