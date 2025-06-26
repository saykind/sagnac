function s = sweep(instruments, s, cnt)
%Sweep instrument parameters.
%   nargin=0: create sweep structure
%   nargin=2: configure instruments pre-measurement
%   nargin=3: make sweep step

    if nargin == 0      % Create sweep structure
        %s = struct('rate', 10, 'pause', 6, 'range', 1e6*(.2:.01:15));
        %s = struct('rate', 10, 'pause', 6, 'range', 1e6*(6:.01:6.3));
        s = struct('rate', 10, 'pause', 6, 'range', 1e6*(9.:.01:9.5));
        s.datapoints = sweep_datapoints(s);
        s.points = sweep_points(s);
        s.record = @(cnt) rem(cnt, s.rate) > s.pause-1;
        s.change = @(cnt) rem(cnt, s.rate) < 1;
        return
    end

    if nargin == 2      % Configure instrument settings (before the measurement)
        val = s.range(1);
        instruments.lockin.set('oscillator_frequency', val);
        return
    end

    if nargin == 3      % Make a sweep step
        i = fix(cnt/s.rate)+1;
        val = s.range(i);
        instruments.lockin.set('oscillator_frequency', val);
        return
    end
end

function p = sweep_datapoints(s)
    k = s.rate-s.pause;
    p = reshape(repmat(s.range,k,1),1,[]);
end

function p = sweep_points(s)
    k = s.rate;
    p = reshape(repmat(s.range,k,1),1,[]);
end