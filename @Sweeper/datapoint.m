function datapoint(obj)
%Reads instrumets' fields and saves them into obj.logdata.

if isempty(obj.instruments)
    disp("Please create instrument structure.");
    return
end

names = obj.schema.name;
for i = 1:numel(names)
    name = names{i};
    instrument = obj.instruments.(name);

    fields = obj.schema.fields{i};
    if isempty(fields), fields = instrument.fields; end
    if isnan(fields{1}), continue; end
    for j = 1:numel(fields)
        field = fields{j};
        obj.logdata.(name).(field) = [obj.logdata.(name).(field); instrument.get(field)];
    end
end


obj.logdata.magnet.polarity = [obj.logdata.magnet.polarity; obj.polarity];

c = clock();
obj.logdata.timer.datetime = [obj.logdata.timer.datetime; c];

d0 = obj.logdata.timer.datetime(1,:); 
t = Sweeper.datetimeToSeconds(c-d0);
obj.logdata.timer.time = [obj.logdata.timer.time; t];

