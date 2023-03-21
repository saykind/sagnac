function instruments = make_instruments(schema)
%Create cell with instrument objects given the scheme.

instruments = struct();

if ~nargin || ~istable(schema)
    warning("make_instruemnts() requires argument of class table (schema)."); 
    return
end

n = height(schema);
for i = 1:n
    name = schema.name{i};
    driver = schema.driver{i};
    address = schema.address(i);
    try
        instruments.(name) = Drivers.(driver)(address);
    catch ME
        disp(ME)
        instruments = [];
        return
    end
end