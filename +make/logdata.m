function logdata = logdata(instruments, schema)
%Create logdata structure with correct fields.

logdata = struct();
logdata.timer = struct();
logdata.timer.time = [];
logdata.timer.datetime = [];

names = schema.name;
for i = 1:numel(names)
    name = names{i};
    instrument = instruments.(name);

    fields = schema.fields{i};
    if isempty(fields), fields = instrument.fields; end
    if isempty(fields), continue; end
    if isnan(fields{1}), continue; end
    logdata.(name) = struct();
    for j = 1:numel(fields)
        field = fields{j};
        logdata.(name).(field) = [];
    end
end
