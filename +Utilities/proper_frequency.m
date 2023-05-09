function proper_frequency(f, filename)
% Reads data from SR844, averages it and records it
% Usage example:
% proper_frequncy(4.8e6);
% proper_frequncy(5e6);

if nargin < 1
    error('Please provide frequency argument.');
end

%% Preamble
gpib = 9;
lockin = Drivers.SR844(gpib);
lockinSensitivity = 250;

numPoints = 10;
pauseTime = 1;

if nargin == 1 
    filename = 'proper_frequency_data.mat';
end

if exist(filename, 'file')
    logdata = load(filename, 'logdata').logdata;
else
    logdata = struct(...
        'f', zeros(1,0), ...
        'X', zeros(1,0), ...
        'X_err', zeros(1,0), ...
        'Y', zeros(1,0), ...
        'Y_err', zeros(1,0), ...
        'R', zeros(1,0), ...
        'R_err', zeros(1,0), ...
        'S', zeros(1,0), ...
        'S_err', zeros(1,0) ...
        );
end


%% Main loop
vals = struct(...
        'X', zeros(1, numPoints), ...
        'Y', zeros(1, numPoints), ...
        'R', zeros(1, numPoints), ...
        'S', zeros(1, numPoints) ...
        );
Utilities.textprogressbar('Collecting data: ', 0);
for i = 1:numPoints
    Utilities.textprogressbar(100*i/numPoints);
    vals.X(i) = lockin.read('X');
    vals.Y(i) = lockin.read('Y');
    vals.R(i) = lockin.read('R');
    vals.S(i) = lockinSensitivity*lockin.read('AUX1');
    pause(pauseTime);
end
Utilities.textprogressbar(' ');

%% Conclusion
logdata.f(end+1) = f;
logdata.X(end+1) = mean(vals.X);
logdata.X_err(end+1) = std(vals.X)/sqrt(numPoints);
logdata.Y(end+1) = mean(vals.Y);
logdata.Y_err(end+1) = std(vals.Y)/sqrt(numPoints);
logdata.R(end+1) = mean(vals.R);
logdata.R_err(end+1) = std(vals.R)/sqrt(numPoints);
logdata.S(end+1) = mean(vals.S);
logdata.S_err(end+1) = std(vals.S)/sqrt(numPoints);

save(filename,  'logdata');

end