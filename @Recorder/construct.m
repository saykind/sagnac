function obj = construct(obj, seed)
    % Covert seed to key
    obj.key = 0;
    if nargin > 1
        obj.seed = seed;
        [key, title] = make.key(seed);
        obj.key = key;
        obj.title = title;
    end
    if isempty(obj.title), obj.title = make.title(obj.key); end

    % Initialize parameters with default values
    obj.schema = make.schema(obj.key);
    obj.sweep = make.sweep(obj.key);
    obj.foldername = "./data";
    if ~exist(obj.foldername, 'dir'), mkdir(obj.foldername); end
    obj.instruments = struct([]);
    obj.loginfo = struct([]);
    obj.logdata = struct([]);
    obj.graphics = struct([]);
    obj.cnt = 0;
    obj.rec = 1;
    obj.rate = struct('timer', 1, 'log', 2, 'plot', 4, 'save', 200);
    if ~isempty(obj.sweep), obj.rate.plot = obj.sweep.rate; end
    obj.verbose = 1;
end