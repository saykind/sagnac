function s = sweep(instruments, s, cnt)
%Sweep instrument parameters.
%   nargin=0: create sweep structure
%   nargin=2: configure instruments pre-measurement
%   nargin=3: make sweep step

    if nargin == 0      % Create sweep structure
        x0 = 9.3;
        y0 = 10.5;
        
        x = x0 + (-.15:.01:.15);
        y = y0 + (-.3:.01:.3);

        [X,Y] = meshgrid(x,y);
        [n,m] = size(X);
        X_flat = util.mesh.column.flatten(X);
        Y_flat = util.mesh.column.flatten(Y);
        %DC measurement min rate is 3s, pause 2s
        %Kerr measurement min rate is 9s, pause 8s
        s = struct('rate', 1, 'pause', 0, ...
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
        instruments.X.handle.MoveTo(val(1), 60e3);
        instruments.Y.handle.MoveTo(val(2), 60e3);
        return
    end

    if nargin == 3      % Make a sweep step
        i = fix(cnt/s.rate);
        if i == 1
            return
        end
        i_prev = i-1;
        try
            val = s.range(:,i);
            val_prev = s.range(:,i_prev);
        catch ME
            util.msg("Failed at cnt=%d.\n", cnt);
            rethrow(ME);
        end
        
        % disp(instruments.watch.datetime);
        % disp(instruments.X.handle.IsDeviceBusy);
        % disp(instruments.X.get('position'));
        % disp(instruments.Y.handle.IsDeviceBusy);
        % disp(instruments.Y.get('position'));

        if val(1) ~= val_prev(1) 
            instruments.X.handle.MoveTo(val(1), 60e3);
        end
        if val(2) ~= val_prev(2) 
            instruments.Y.handle.MoveTo(val(2), 60e3);
        end
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