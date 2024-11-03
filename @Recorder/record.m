function record(obj)
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
    if isempty(fields), continue; end
    if isnan(fields{1}), continue; end
    for j = 1:numel(fields)
        field = fields{j};
        dat = 0;
        try
            dat = instrument.get(field);
        catch
            fprintf("[Recorder.record] Failed to get instrument data.\n");
            fprintf("[Recorder.record] problematic field = %s\n", field);
        end
        %fprintf("%s : %f\n", field, dat);
        obj.logdata.(name).(field) = [obj.logdata.(name).(field); dat];
    end
end

c = util.datetime.clock();
obj.logdata.timer.datetime = [obj.logdata.timer.datetime; c];

d0 = obj.logdata.timer.datetime(1,:); 
t = util.datetime.toseconds(c-d0);
obj.logdata.timer.time = [obj.logdata.timer.time; t];

