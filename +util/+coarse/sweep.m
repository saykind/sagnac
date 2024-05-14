function varargout = sweep(sweep, varargin)
%SWEEP averages data over a sweep step

    k = sweep.rate-sweep.pause;
    k = k(1);
    n = numel(varargin{1});
    m = fix(n/k);

    for i = 1:numel(varargin)
        avg = mean(reshape(varargin{i}, [k, m]),1);
        dev = std(reshape(varargin{i}, [k, m]), 0, 1);
        varargout{i} = avg;
        varargout{i+numel(varargin)} = dev;
    end