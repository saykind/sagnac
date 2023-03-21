function info = info(instruments, schema)
%Reads instrumets' paramters and returns them as structure.

info = struct();

if ~nargin, return, end

if nargin == 1
    names = fieldnames(instruments);
    parameterSets = cell(1, numel(names));
else
    names = schema.name;
    parameterSets = schema.parameters;
end

for i = 1:numel(names)
    name = names{i};
    instrument = instruments.(name);
    
    info.(name).driver = instrument.name;
    info.(name).interface = instrument.interface;
    info.(name).address = instrument.address;
    
    parameters = parameterSets{i};
    if isempty(parameters), parameters = instrument.parameters; end
    if isnan(parameters{1}), continue; end
    for j = 1:numel(parameters)
        parameter = parameters{j};
        info.(name).(parameter) = instrument.get(parameter);
    end
end