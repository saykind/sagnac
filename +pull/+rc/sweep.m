function s = sweep(instruments, s, cnt)
%Sweep instrument parameters.
%   nargin=0: create sweep structure
%   nargin=2: configure instruments pre-measurement
%   nargin=3: make sweep step

    if nargin == 0      % Create sweep structure
        v1 = 5;
        v2 = 1.3;
        step = -0.02;
        range = [v1:step:v2];
        s = struct('rate', 2, 'pause', 1, 'range', range);

        s.datapoints = sweep_datapoints(s);
        s.points = sweep_points(s);
        s.record = @(cnt) rem(cnt, s.rate) > s.pause-1;
        s.change = @(cnt) rem(cnt, s.rate) < 1;
        return
    end

    if nargin == 2      % Configure instrument settings (before the measurement)
        val = s.range(1);

        v0 = instruments.lockinA.get('AUXV1');
        if abs(v0-val) > 2e-3
            error("[11682] Voltage sweep range has incorrect v0.")
        else
            %instruments.lockin.ramp(val);
            instruments.lockinA.set('AUXV1', val);
        end

        return
    end

    if nargin == 3      % Make a sweep step
        i = fix(cnt/s.rate)+1;
        val = s.range(i);
        instruments.lockinA.set('AUXV1', val);
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