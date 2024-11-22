function s = sweep(instruments, s, cnt)
%Sweep instrument parameters.
%   nargin=0: create sweep structure
%   nargin=2: configure instruments pre-measurement
%   nargin=3: make sweep step

    if nargin == 0      % Create sweep structure
        f = 1e6*(.1:.1:14);
        a = [0:.02:2.5];
        [F,A] = meshgrid(f,a);
        [n,m] = size(F);
        F_flat = flatten_mesh(F);
        A_flat = flatten_mesh(A);
        s = struct('rate', 5, 'pause', 3, 'range', [F_flat; A_flat], 'shape', [n,m]);

        s.datapoints = sweep_datapoints(s);
        s.points = sweep_points(s);
        s.record = @(cnt) rem(cnt, s.rate) > s.pause-1;
        s.change = @(cnt) rem(cnt, s.rate) < 1;
        return
    end

    if nargin == 2      % Configure instrument settings (before the measurement)
        val = s.range(:,1);
        instruments.lockin.set('oscillator_frequency', val(1));
        instruments.lockin.set('output_amplitude', val(2));
        return
    end

    if nargin == 3      % Make a sweep step
        i = fix(cnt/s.rate)+1;
        val = s.range(:,i);
        instruments.lockin.set('oscillator_frequency', val(1));
        instruments.lockin.set('output_amplitude', val(2));
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

function z = flatten_mesh(Z)
    [n, m] = size(Z);
    n0 = n*m;
    z = zeros(1,n0);
    for i0 = 0:n0-1
        i = fix(i0/m)+1;
        j = mod(i0,m)+1;
        if ~mod(i,2)
            j = m-j+1;
        end
        z(i0+1) = Z(i,j);
    end
end