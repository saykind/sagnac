function s = sweep(key, instruments, s, cnt)
    %Sweeps instrument parameters.
    %   nargin=1: create sweep structure for a given key.
    %   nargin=3: configure instruments pre-measurement
    %   nargin=4: make sweep step.
    %   nargin=5: make a simulation of measurement.

    if isstring(key), key = make.key(key); end
    
    %% Create sweep strucutre
    if nargin == 1
        switch key
            case {112, 100, 477128}  
                %d: DC voltage, Keithley 2182A
                %p: Optical power measurement, Newport 1830-C
                %LIV:  Laser IV characteristic
                s = struct('rate', 3, 'pause', 1, ...
                    'range', 0:2:100);

            case {102, 'f'}
                s = struct('rate', 20, 'pause', 6, ...
                    'range', 1e6*[4.78:.001:4.82]);
                
            case 12444
                %zf: Modulation frequency sweep
                s = struct('rate', 10, 'pause', 6, ...
                    'range', 1e6*[9.15:.005:9.30]);

            case {97, 'a'}
                %a: Modulation amplitude sweep
                s = struct('rate', 6, 'pause', 4, ...
                    'range', [.1:.1:5]);

            case 11834
                %za: Amplitude sweep
                s = struct('rate', 10, 'pause', 6, ...
                    'range', 0:.01:2);

            case 1313574
                %zao: Amplitude offset set
                vmax = 10;
                step = .1;
                s = struct('rate', 2, 'pause', 1, ...
                    'range', [0:step:vmax, (vmax-step):-step:-vmax, (-vmax+step):step:0]);

            case {1076922, 1327116}
                %bco: BCB offset voltage sweep
                %zbo: BCB offset voltage sweep
                vmax = 10;
                step = .2;
                s = struct('rate', 2, 'pause', 1, ...
                    'range', [0:step:vmax, (vmax-step):-step:-vmax, (-vmax+step):step:0]);

            case 9894
                %fa: Modulation 2D sweep
                f = 1e6*(4:.05:6.5);
                a = [.05:.05:2];
                [F,A] = meshgrid(f,a);
                [n,m] = size(F);
                F_flat = flatten_mesh(F);
                A_flat = flatten_mesh(A);
                s = struct('rate', 100, 'pause', 10, ...
                    'range', [F_flat; A_flat], 'shape', [n,m]);

            case 1207068
                %zfa: Modulation 2D sweep
                f = 1e6*(9:.005:9.4);
                a = [0:.1:2];
                [F,A] = meshgrid(f,a);
                [n,m] = size(F);
                F_flat = util.mesh.reshape([n,m], F);
                A_flat = util.mesh.reshape([n,m], A);
                s = struct('rate', 10, 'pause', 8, ...
                    'range', [F_flat; A_flat], 'shape', [n,m]);
                
            case 9603   %ca: laser current and modulation amplitude sweep
                c = [0:3:30];
               a = [.01, (.1:.2:2)];
                [C,A] = meshgrid(c,a);
                [n,m] = size(C);
                C_flat = flatten_mesh(C);
                A_flat = flatten_mesh(A);
                s = struct('rate', 200, 'pause', 10, ...
                    'range', [C_flat; A_flat], 'shape', [n,m]);
                
            case {14520, 1771440} 
                %xy: Kerr 2D scan
                %zxy: Kerr XY scan
                x0 = 13;
                y0 = 13;
                
                x = x0 + (-.3:.006:.3);
                y = y0 + (-.3:.006:.6);

                [X,Y] = meshgrid(x,y);
                [n,m] = size(X);
                X_flat = flatten_mesh(X);
                Y_flat = flatten_mesh(Y);
                %DC measurement min rate is 3s, pause 2s
                %Kerr measurement min rate is 9s, pause 8s
                s = struct('rate', 3, 'pause', 2, ...
                    'range', [X_flat; Y_flat], 'shape', [n,m], ...
                    'origin', [x0, y0]);

            case {120, 14640}
                %x: Kerr 1D scan
                %zx: Kerr 1D scan
                x0 = 13;
                x = x0 + (1.5:.01:2.4);
                s = struct('rate', 3, 'pause', 2, ...
                    'range', x, 'origin', x0);

            case {105, 12810}
                %i: laser current sweep
                %zi: laser current sweep
                curr_min = 120;  % current, mA
                step = 10;
                curr_max = 190;
                range = [curr_min:step:curr_max, ...
                    (curr_max-.5*step):-step:curr_min];
                s = struct('rate', 30, 'pause', 10, 'range', range);

            case {121, 11128, 1346488, 14762}    
                %y: Hysteresis test
                %hk: Kerr vs field
                %khy: Kerr vs field
                %zy: Kerr vs field
                mag = 1200;  % current, mA
                sgn = 1;
                step = 400;
                range = sgn*1e-3*[0:step:mag, ...
                    (mag-.5*step):-step:0, 0];
                s = struct('rate', 40, 'pause', 10, 'range', range, 'sign', sgn);

            case 1388970
                %zcs: Kerr vs current sweep
                mag = 34;   %  mA
                step = 1;   %  mA
                %range = 1e-3*[0:step:mag, (mag-.5*step):-step:0, 0];
                range = 1e-3*[0:step:mag, ...
                    (mag-.5*step):-step:(-mag+.5*step), ...
                    (-mag):step:0];
                s = struct('rate', 30, 'pause', 10, 'range', range);

            case 11960  %hs: Hall sensor
                mag = 600;
                step = 50;
                range = 1e-3*[...
                        0:step:mag, ...
                        (mag-step):-step:0];
                s = struct('rate', 5, 'pause', 3, 'range', range);

            case 11948    %tg: Two transport lockins & gate voltage controller
                range = [0:.05:4];
                s = struct('rate', 2, 'pause', 1, 'range', range);

            case 1278436  %ktg: Kerr, transport, gate
                range = [-5.4:.2:0];
                s = struct('rate', 20, 'pause', 5, 'range', range);

            case 11832  %tf: Transport freq sweep
                range = 1e3*[.001:.001:.019, .02:.01:1, 1.05:.05:10];
                s = struct('rate', 9, 'pause', 8, 'range', range);

            case {11682, 11286, 13110, 1546980}
                %cv: Capacitance vs voltage
                %cr: Capacitance, Resistance vs voltage
                %sr: Strain + resistance (no bridge)
                %rsv: Resistance vs AUXV1 (strain voltage) (no bridge)
                v1 = 3.96;
                v2 = 0;
                step = -0.05;
                range = [v1:step:v2];
                s = struct('rate', 2, 'pause', 1, 'range', range);
                
            case 10593  %kc: kerr vs strain (capacitance)
                range = (-2:-0.05:-6.9);
                s = struct('rate', 5, 'pause', 3, 'range', range);

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

            case 12444
                %zf: Modulation frequency sweep
                instruments.lockin.set('oscillator_frequency', val);

            case {97, 'a'}
                instruments.waveform.set('ampl', val);

            case 11834
                %za: Amplitude sweep
                instruments.lockin.set('output_amplitude', val);

            case 1313574
                %zao: Amplitude offset set
                instruments.lockin.set('output_offset', val);

            case {1076922, 1327116}
                %bco: BCB offset voltage sweep
                %zbo: BCB offset voltage sweep
                instruments.bcb.set('voltage', val);

            case {9894, 'fa'}
                val = s.range(:,1);
                instruments.waveform.set('freq', val(1));
                instruments.waveform.set('ampl', val(2));

            case 1207068
                %zfa: Modulation 2D sweep
                val = s.range(:,1);
                instruments.lockin.set('oscillator_frequency', val(1));
                instruments.lockin.set('output_amplitude', val(2));

            case {9603, 'ca'}
                val = s.range(:,1);
                instruments.diode.output(val(1));
                instruments.waveform.set('ampl', val(2));

            case {14520, 1771440} 
                %xy: Kerr 2D scan
                %zxy: Kerr XY scan
                val = s.range(:,1);
                instruments.X.set('position', val(1));
                instruments.Y.set('position', val(2));

            case {120, 14640}
                %x: Kerr 1D scan
                %zx:
                instruments.X.set('position', val);

            case {105, 12810}
                %i: laser current sweep
                %zi: laser current sweep
                instruments.diode.output(val);

            case {121, 11128, 1346488, 14762}    
                %y: Hysteresis test
                %hk: Kerr vs field
                %khy:
                %zy: Kerr vs field
                instruments.magnet.output(abs(val));

            case 1388970
                %zcs: Kerr vs current sweep
                instruments.source.apply(val);

            case {11960, make.key('hs:')} % Hall sensor
                instruments.magnet.output(abs(val));

            case 11948    %tg: Two transport lockins & gate voltage controller
                instruments.source.ramp(val);

            case 1278436    %ktg: kerr, tansport, gate
                instruments.source.ramp(val);

            case 11832  %tf: Transport freq sweep
                instruments.lockin.set('f', val);

            case {11682, 11286, 13110, 1546980}
                %cv: Capacitance vs voltage
                %cr: Capacitance, Resistance vs voltage
                %sr: Strain + resistance (no bridge)
                %rsv: Resistance vs AUXV1 (strain voltage)
                v0 = instruments.lockin.get('AUXV1');
                if abs(v0-val) > 2e-3
                    error("[11682] Voltage sweep range has incorrect v0.")
                else
                    %instruments.lockin.ramp(val);
                    instruments.lockin.set('AUXV1', val);
                end

            case 10593
                %kc: kerr vs strain (capacitance)
                v0 = instruments.lockinA.get('AUXV1');
                if abs(v0-val) > 2e-3
                    error("[11682] Voltage sweep range has incorrect v0.")
                else
                    instruments.lockinA.ramp(val);
                end
        end
        return
    end
    
    
    %% Make a sweep step
    if nargin == 4
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

            case 12444
                %zf: Modulation frequency sweep
                instruments.lockin.set('oscillator_frequency', val);

            case {97, 'a'}
                instruments.waveform.set('ampl', val);

            case 11834
                %za: Amplitude sweep
                instruments.lockin.set('output_amplitude', val);

            case 1313574
                %zao: Amplitude offset set
                instruments.lockin.set('output_offset', val);

            case {1076922, 1327116}
                %bco: BCB offset voltage sweep
                %zbo: BCB offset voltage sweep
                instruments.bcb.set('voltage', val);

            case {9894, 'fa'}
                val = s.range(:,i);
                instruments.waveform.set('freq', val(1));
                instruments.waveform.set('ampl', val(2));
            
            case 1207068
                %zfa: Modulation 2D sweep
                val = s.range(:,i);
                instruments.lockin.set('oscillator_frequency', val(1));
                instruments.lockin.set('output_amplitude', val(2));

            case {9603, 'ca'}
                val = s.range(:,i);
                instruments.diode.output(val(1));
                instruments.waveform.set('ampl', val(2));

            case {14520, 1771440} 
                %xy: Kerr 2D scan
                %zxy: Kerr XY scan
                try
                    val = s.range(:,i);
                catch ME
                    fprintf("[make.sweep] Failed at cnt=%d.\n", cnt);
                    rethrow(ME);
                end
                instruments.X.set('position', val(1));
                instruments.Y.set('position', val(2));

            case {120, 14640}
                %x: Kerr 1D scan
                %zx:
                instruments.X.set('position', val);

            case {105, 12810}
                %i: laser current sweep
                %zi: laser current sweep
                instruments.diode.output(val);

            case {121, 11128, 1346488, 14762}    
                %y: Hysteresis test
                %hk: Kerr vs field
                %khy:
                %zy: Kerr vs field
                instruments.magnet.output(abs(val));
%                 if val == 0 
%                     sound(sin(1:5000));
%                     input("Check magnet polarity. Press return to continue.", "s");
%                 end

            case 1388970
                %zcs: Kerr vs current sweep
                instruments.source.apply(val);

            case {11960, make.key('hs:')} % Hall sensor
                instruments.magnet.output(abs(val));

            case 11948    %tg: Two transport lockins & gate voltage controller
                instruments.source.ramp(val);

            case 1278436    %ktg: kerr, tansport, gate
                instruments.source.ramp(val);

            case 11832  %tf: Transport freq sweep
                instruments.lockin.set('f', val);

            case {11682, 11286, 13110, 1546980}
                %cv: Capacitance vs voltage
                %kc: kerr vs strain (capacitance)
                %cr: Capacitance, Resistance vs voltage
                %sr: Strain + resistance (no bridge)
                %rsv: Resistance vs AUXV1 (strain voltage)

                %instruments.lockin.ramp(val);
                instruments.lockin.set('AUXV1', val);

            case 10593
                %cv: Capacitance vs voltage
                %kc: kerr vs strain (capacitance)
                instruments.lockinA.ramp(val);
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
