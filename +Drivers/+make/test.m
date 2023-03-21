schema = Drivers.make.schema();
instruments = Drivers.make.instruments(schema);
%info = Drivers.make.info(instruments);
info = Drivers.make.info(instruments, schema);
datapoint = Drivers.make.datapoint(instruments, schema);
data = datapoint;

util.textprogressbar(sprintf('i=%d: ', i), 0);
n = 5;
for i = 1:n
    util.textprogressbar(100*i/n);
    data = Drivers.make.data(data, instruments, schema);
    pause(0.1);
end
util.textprogressbar(' ');