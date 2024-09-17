function [instruments, instr] = instruments(schema, instr)
%Create cell with instrument objects given the scheme.
%If instr is given, take available instruments from it, create the rest.
arguments
    schema table
    instr struct = struct()
end

instruments = struct();

for i = 1:height(schema)
    name = schema.name{i};
    if isfield(instr, name)
        instruments.(name) = instr.(name);
        continue
    end
    driver = schema.driver{i};
    address = schema.address(i);
    try
        instruments.(name) = Drivers.(driver)(address);
    catch ME
        util.msg("Failed to initialize %s.\n", driver);
        disp(ME)
        instruments = [];
        return
    end
    instr.(name) = instruments.(name);
end