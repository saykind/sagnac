function s = sweep(instruments, s, cnt)
%Sweep instrument parameters.
%   nargin=0: create sweep structure
%   nargin=2: configure instruments pre-measurement
%   nargin=3: make sweep step

    if nargin == 0      % Create sweep structure
        x0 = 13;
        y0 = 13;
        
        x = x0 + (-.4:.01:.4);
        y = y0 + (-.4:.01:.4);

        [X,Y] = meshgrid(x,y);
        [n,m] = size(X);
        X_flat = util.mesh.flatten(X);
        Y_flat = util.mesh.flatten(Y);
        %DC measurement min rate is 3s, pause 2s
        %Kerr measurement min rate is 9s, pause 8s
        s = struct('rate', 3, 'pause', 2, ...
            'range', [X_flat; Y_flat], 'shape', [n,m], ...
            'origin', [x0, y0]);
        s.datapoints = sweep_datapoints(s);
        s.points = sweep_points(s);
        s.record = @(cnt) rem(cnt, s.rate) > s.pause-1;
        s.change = @(cnt) rem(cnt, s.rate) < 1;
        return
    end

    if nargin == 2      % Configure instrument settings (before the measurement)
        val = s.range(:,1);
        instruments.X.set('position', val(1));
        instruments.Y.set('position', val(2));
        return
    end

    if nargin == 3      % Make a sweep step
        i = fix(cnt/s.rate);
        try
            val = s.range(:,i);
        catch ME
            util.msg("Failed at cnt=%d.\n", cnt);
            rethrow(ME);
        end
        instruments.X.set('position', val(1));
        instruments.Y.set('position', val(2));
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