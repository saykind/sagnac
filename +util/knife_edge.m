function knife_edge(x, filename)
% Reads data from SR844, averages it and records it
% Usage example:
% knife_edge(0);
% knife_edge(5);

if nargin < 1
    error('Please provide distance argument.');
end

%% Preamble
gpib = 8;
lockin = Drivers.SR844(gpib);
lockinSensitivity = 250;

numPoints = 10;
pauseTime = 1;

if nargin == 1 
    filename = 'knife_edge_data.mat';
end

if exist(filename, 'file')
    logdata = load(filename, 'logdata').logdata;
else
    logdata = struct(...
        'x', zeros(1,0), ...
        'y', zeros(1,0), ...
        'y_err', zeros(1,0) ...
        );
end


%% Main loop
vals = zeros(1,numPoints);
Utilities.textprogressbar('Collecting data: ', 0);
for i = 1:numPoints
    Utilities.textprogressbar(100*i/numPoints);
    vals(i) = lockinSensitivity*lockin.read('AUX1');
    pause(pauseTime);
end
Utilities.textprogressbar(' ');

%% Conclusion
logdata.x(end+1) = x;
logdata.y(end+1) = mean(vals);
logdata.y_err(end+1) = std(vals)/sqrt(numPoints);

save(filename,  'logdata');

end