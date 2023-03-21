function data = data(instruments, schema)
%Reads instrumets' paramters and returns them as structure.

data = struct();

if ~nargin, return, end

if nargin == 1
    names = fieldnames(instruments);
    fieldSets = cell(1, numel(names));
else
    names = schema.name;
    fieldSets = schema.fields;
end

for i = 1:numel(names)
    name = names{i};
    instrument = instruments.(name);
    
    fields = fieldSets{i};
    if isempty(fields), fields = instrument.fields; end
    if isnan(fields{1}), continue; end
    for j = 1:numel(fields)
        field = fields{j};
        data.(name).(field) = instrument.get(field);
    end
end