function s = sweep(instruments, s, cnt)
%Sweep instrument parameters.
%   nargin=0: create sweep structure
%   nargin=2: configure instruments pre-measurement
%   nargin=3: make sweep step

%   AXIS: Y

    if nargin == 0      % Create sweep structure
        x0 = 16.465;        
        x = x0 + (-.02:.002:.02);

        %DC measurement min rate is 3s, pause 2s
        %Kerr measurement min rate is 9s, pause 8s
        s = struct('rate', 5, 'pause', 1, 'range', x);
        s.datapoints = sweep_datapoints(s);
        s.points = sweep_points(s);
        s.record = @(cnt) rem(cnt, s.rate) > s.pause-1;
        s.change = @(cnt) rem(cnt, s.rate) < 1;
        return
    end

    if nargin == 2      % Configure instrument settings (before the measurement)
        val = s.range(1);
        instruments.X.set(position=val, timeout=NaN);
        return
    end

    if nargin == 3      % Make a sweep step
        i = fix(cnt/s.rate);
        try
            val = s.range(i);
        catch ME
            util.msg("Failed at cnt=%d.\n", cnt);
            rethrow(ME);
        end
        instruments.X.set(position=val, timeout=NaN);
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