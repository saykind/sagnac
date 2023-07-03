function s = sweep(key, instruments, s, cnt)
    %Sweeps instrument parameters.
    %   nargin=1: create sweep structure for a given key.
    %   nargin=3: configure instruments pre-measurement
    %   nargin=4: make sweep step.
    %   nargin=5: make a simulation of measurement.
    
    %% Create sweep strucutre
    if nargin == 1
        switch key
            case {112, 'p', 100, 'd'}   % d :
                s = struct('rate', 30, 'pause', 10, ...
                    'range', 37:1:55);
            case {102, 'f'}
                s = struct('rate', 20, 'pause', 18, ...
                    'range', 1e6*[0.001, .1:.1:12]);
            case {97, 'a'}
                s = struct('rate', 12, 'pause', 10, ...
                    'range', [.001, .02:.02:5]);
            case 9894   %fa: Modulation 2D sweep
                f = 1e6*(4.5:.1:5.2);
                a = 1.1:0.05:1.3;
                [F,A] = meshgrid(f,a);
                [n,m] = size(F);
                F_flat = flatten_mesh(F);
                A_flat = flatten_mesh(A);
                s = struct('rate', 11, 'pause', 10, ...
                    'range', [F_flat; A_flat], 'shape', [n,m]);
                
            case 14520 %xy: Kerr 2D scan
                x0 = 0;
                y0 = 0;
                x = x0 + 0:.2:5;
                y = y0 + 0:.2:5;
                [X,Y] = meshgrid(x,y);
                [n,m] = size(X);
                X_flat = flatten_mesh(X);
                Y_flat = flatten_mesh(Y);
                %DC measurement min rate is 3s
                %Kerr measurement min rate is ~10 s
                s = struct('rate', 2, 'pause', 1, ...
                    'range', [X_flat; Y_flat], 'shape', [n,m]);
                
                
            case 120 %x: Kerr 1D scan
                x0 = 13;
                x = x0 + [-2:.05:2];
                s = struct('rate', 40, 'pause', 10, ...
                    'range', x);
                
            case {105, 'i'}
                s = struct('rate', 30, 'pause', 5, 'range', 65:1:95);
                
            case 121    %y: Hysteresis test
                mag = 400;  % current, A
                step = 50;
                range = 1e-3*[...
                        0:step:mag, ...
                        (mag-step):-step:0];
                s = struct('rate', 30, 'pause', 5, 'range', range);
                
            case 11960  %hs: Hall sensor
                mag = 300;
                step = 10;
                range = 1e-3*[...
                        0:step:mag, ...
                        (mag-step):-step:0];
                s = struct('rate', 10, 'pause', 5, 'range', range);
            otherwise
                s = struct([]);
        end
        if ~isempty(s)
            s.datapoints = sweep_datapoints(s);
            s.points = sweep_points(s);
        end
        return
    end
    
    %% Configure instrument settings (before the measurement)
    if nargin == 3
        val = s.range(1);
        switch key
            case {112, 'p', 100, 'd'}
                instruments.diode.set('output', 1);
                instruments.diode.set('current', val);
            case {102, 'f'}
                instruments.waveform.set('freq', val);
            case {97, 'a'}
                instruments.waveform.set('ampl', val);
            case {9894, 'fa'}
                val = s.range(:,1);
                instruments.waveform.set('freq', val(1));
                instruments.waveform.set('ampl', val(2));
            case 14520  %xy: Kerr 2D scan
                val = s.range(:,1);
                instruments.X.set('position', val(1));
                instruments.Y.set('position', val(2));
            case 120  %x: Kerr 1D scan
                instruments.Y.set('position', val);
            case {105, 'i'}
                instruments.diode.output(val);
            case {121, 'y'}
                instruments.magnet.output(abs(val));
            case {11960, make.key('hs:')} % Hall sensor
                instruments.magnet.output(abs(val));
        end
        return
    end
    
    
    %% Make a sweep step
    if nargin == 4
        i = fix(cnt/s.rate);
        val = s.range(i);
        switch key
            case {112, 'p', 100, 'd'}
                instruments.diode.set('current', val);
            case {102, 'f'}
                instruments.waveform.set('freq', val);
            case {97, 'a'}
                instruments.waveform.set('ampl', val);
            case {9894, 'fa'}
                val = s.range(:,i);
                instruments.waveform.set('freq', val(1));
                instruments.waveform.set('ampl', val(2));
            case 14520  %xy: Kerr 2D scan
                val = s.range(:,i);
                instruments.X.set('position', val(1));
                instruments.Y.set('position', val(2));
            case 120  %x: Kerr 1D scan
                instruments.Y.set('position', val);
            case {105, 'i'}
                instruments.diode.output(val);
            case {121, 'y'}
                instruments.magnet.output(abs(val));
                if val == 0
                    sound(sin(1:5000));
                    input("Check magnet polarity. Press return to continue.", "s");
                end
            case {11960, make.key('hs:')} % Hall sensor
                instruments.magnet.output(abs(val));
        end
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
