function init(obj, options)
% Initialize Logan object.

arguments
    obj (1,1) Logan
    options.schema = table();
    options.instruments (1,1) struct = struct()
    options.verbose (1,1) double {mustBeInteger, mustBeNonnegative} = 0
end

obj.verbose = options.verbose;

if isempty(options.schema) && isempty(options.instruments)
    error('Either schema or instruments must be provided.');
end

if isempty(options.schema)
    obj.schema = make.instruments2schema(options.instruments); %FIXME
else
    obj.schema = options.schema;
    obj.instruments = make.schema2instruments(obj.schema); %FIXME
end