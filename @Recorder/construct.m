function obj = construct(obj, seed)
    obj.key = 0;
    if nargin > 1
        obj.seed = seed;
        obj.key = make.key(seed);
    end

    % Initialize parameters with default values
    obj.title = make.title(obj.key);
    obj.schema = make.schema(obj.key);
    obj.sweep = make.sweep(obj.key);
    obj.foldername = "data";
    obj.instruments = struct([]);
    obj.loginfo = struct([]);
    obj.logdata = struct([]);
    obj.graphics = struct([]);
    obj.cnt = 0;
    obj.rec = 1;
    obj.rate = struct('timer', 1, 'log', 1, 'plot', 2, 'save', 100);
    if ~isempty(obj.sweep), obj.rate.plot = 2*obj.sweep.rate; end
    obj.verbose = 1;
end