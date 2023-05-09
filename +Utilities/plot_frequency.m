filelist = [...
    "2020-8-6-16-51", ...
    "2020-8-6-16-58", ...
    "2020-8-6-17-5", ...
    "2020-8-6-17-12", ...
    "2020-8-6-17-19", ...
    "2020-8-6-17-26", ...
    "2020-8-6-17-32", ...
    "2020-8-6-17-39", ...
    "2020-8-6-17-46", ...
    "2020-8-6-17-53", ...
    "2020-8-6-18-0"
    ];
filelist = arrayfun(@(x) ('kerrLog/' + x), filelist);
n = numel(filelist);
startFrequency = 4.815;
stepFrequency = .005;
stopFrequency = startFrequency + stepFrequency*(n-1);

f = startFrequency:stepFrequency:stopFrequency;

m = 300;
first = zeros(1,n);
firsty = zeros(1,n);
second = zeros(1,n);
mag = zeros(1,n);
for i = 1:n
    l = load(filelist(i), 'logdata');
    logdata = l.logdata;
    first(i) = mean(logdata.first);
    firsty(i) = mean(logdata.firsty);
    second(i) = mean(logdata.second);
    mag(i) = mean(sqrt(logdata.first.^2+logdata.firsty.^2));
end

figure('Name', 'First X');
plot(f, first, '.', 'MarkerSize', 20);
grid on;

figure('Name', 'First Y');
plot(f, firsty, '.', 'MarkerSize', 20);
grid on;

figure('Name', 'Second X');
plot(f, second, '.', 'MarkerSize', 20);
grid on;

figure('Name', 'First Mag');
plot(f, mag, '.', 'MarkerSize', 20);
grid on;





