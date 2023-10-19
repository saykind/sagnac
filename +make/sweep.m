function s = sweep(key, instruments, s, cnt)
    %Sweeps instrument parameters.
    %   nargin=1: create sweep structure for a given key.
    %   nargin=3: configure instruments pre-measurement
    %   nargin=4: make sweep step.
    %   nargin=5: make a simulation of measurement.
    
    %% Create sweep strucutre
    if nargin == 1
        switch key
            case {112, 100, 477128}  
                %d: DC voltage, Keithley 2182A
                %p: Optical power measurement, Newport 1830-C
                %LIV:  Laser IV characteristic
                s = struct('rate', 3, 'pause', 2, ...
                    'range', 0:2:150);
            case {102, 'f'}
                s = struct('rate', 10, 'pause', 8, ...
                    'range', 1e6*[0.02, .15:.15:9.9]);
            case {97, 'a'}
                s = struct('rate', 10, 'pause', 8, ...
                    'range', [.01, .02:.02:5]);
            case 9894   %fa: Modulation 2D sweep
                f = 1e6*(4:.01:6);
                a = [.01, .1:.1:5];
                [F,A] = meshgrid(f,a);
                [n,m] = size(F);
                F_flat = flatten_mesh(F);
                A_flat = flatten_mesh(A);
                s = struct('rate', 10, 'pause', 9, ...
                    'range', [F_flat; A_flat], 'shape', [n,m]);
                
            case 14520 %xy: Kerr 2D scan
                x0 = 12.2;
                y0 = 12.64;
                x = x0 + (-.4:.04:.4);
                y = y0 + (-.4:.04:.4);
                [X,Y] = meshgrid(x,y);
                [n,m] = size(X);
                X_flat = flatten_mesh(X);
                Y_flat = flatten_mesh(Y);
                %DC measurement min rate is 3s, pause 2s
                %Kerr measurement min rate is 9s, pause 8s
                s = struct('rate', 3, 'pause', 2, ...
                    'range', [X_flat; Y_flat], 'shape', [n,m], ...
                    'origin', [x0, y0]);
                
            case 120 %x: Kerr 1D scan
                x0 = 13;
                x = x0 + (-.5:.02:.5);
                s = struct('rate', 3, 'pause', 2, ...
                    'range', x, 'origin', x0);
                
            case {105, 'i'}
                s = struct('rate', 30, 'pause', 5, 'range', 65:1:95);
                
            case 121    %y: Hysteresis test
                mag = 3000;  % current, mA
                step = 300;
                range = 1e-3*[0:step:mag, ...
                    (mag-step):-step:0];
                s = struct('rate', 30, 'pause', 8, 'range', range);
                
            case 11960  %hs: Hall sensor
                mag = 300;
                step = 50;
                range = 1e-3*[...
                        0:step:mag, ...
                        (mag-step):-step:0];
                s = struct('rate', 5, 'pause', 3, 'range', range);
                
            case 11948    %tg: Two transport lockins & gate voltage controller
                mag = 1.5;  %mV
                step = .05;  %mV
                %range = 1e-3*[0:-step:-mag, -mag:step:mag, (mag-step):-step:0];
                range = [2:-step:0];
                s = struct('rate', 2, 'pause', 1, 'range', range);
                
            case 11832  %tf: Transport freq sweep
                range = 1e3*[.001:.001:.019, .02:.01:1, 1.05:.05:10];
                s = struct('rate', 9, 'pause', 8, 'range', range);
                
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
            case {112, 100, 477128}
                %d: DC voltage, Keithley 2182A
                %p: Optical power measurement, Newport 1830-C
                %LIV:  Laser IV characteristic
                instruments.diode.output(val);
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
                instruments.X.set('position', val);
            case {105, 'i'}
                instruments.diode.output(val);
            case {121, 'y'}
                instruments.magnet.output(abs(val));
            case {11960, make.key('hs:')} % Hall sensor
                instruments.magnet.output(abs(val));
            case 11948    %tg: Two transport lockins & gate voltage controller
                instruments.source.sweep_to(val);
            case 11832  %tf: Transport freq sweep
                instruments.lockin.set('f', val);
        end
        return
    end
    
    
    %% Make a sweep step
    if nargin == 4
        %i = fix(loginfo.logger.TasksExecuted/s.rate);
        i = fix(cnt/s.rate);
        val = s.range(i);
        switch key
            case {112, 100, 477128}
                %d: DC voltage, Keithley 2182A
                %p: Optical power measurement, Newport 1830-C
                %LIV:  Laser IV characteristic
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
                try
                    val = s.range(:,i);
                catch ME
                    fprintf("[make.sweep] Failed at cnt=%d.\n", cnt);
                    rethrow(ME);
                end
                instruments.X.set('position', val(1));
                instruments.Y.set('position', val(2));
            case 120  %x: Kerr 1D scan
                instruments.X.set('position', val);
            case {105, 'i'}
                instruments.diode.output(val);
            case {121, 'y'}
                instruments.magnet.output(abs(val));
%                 if val == 0 
%                     sound(sin(1:5000));
%                     input("Check magnet polarity. Press return to continue.", "s");
%                 end
            case {11960, make.key('hs:')} % Hall sensor
                instruments.magnet.output(abs(val));
            case 11948    %tg: Two transport lockins & gate voltage controller
                instruments.source.sweep_to(val);
            case 11832  %tf: Transport freq sweep
                instruments.lockin.set('f', val);
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
