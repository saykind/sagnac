function s = sweep(key, instruments, s, cnt)
    
    %% Create sweep strucutre
    if nargin == 1
        switch key
            case {112, 'p'}
                s = struct('rate', 5, 'pause', 3, ...
                    'range', [1:.2:19.8, 20:.1:140]);
            case {100, 'd'}
                s = struct('rate', 5, 'pause', 3, ...
                    'range', 0:.2:140);
            otherwise
                s = struct([]);
        end
        return
    end
    
    %% Configure instrument settings
    % What about configuring instruments after measurement is over?
    if nargin == 2
        return
    end
    
    %% Make a sweep step
    switch key
        case {112, 'p'}
            i = fix(cnt/s.rate);
            val = s.range(i);
            instruments.diode.set('current', val);
        case {100, 'd'}
            i = fix(cnt/s.rate);
            val = s.range(i);
            instruments.diode.set('current', val);
    end
end