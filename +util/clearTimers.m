function clearTimers(verbose, tag)
    if nargin < 1, verbose = 1; end
    if nargin < 2
        timers = timerfindall();
    else
        timers = timerfindall('Tag', tag);
    end
    if verbose && numel(timers) > 1
        disp(timers);
    end
    if ~isempty(timers)
        for i = 1:numel(timers)
            t = timers(i);
            name = t.Name;
            if strcmp(t.Running, 'on')
                t.stop();
                if verbose
                    fprintf(['[DeleteAllTimers]', name, ' stopped.\n']); 
                end
            end
            if verbose
                fprintf(['[DeleteAllTimers]', name, ' deleting...\n']); 
            end
            delete(t);
            if verbose
                fprintf(['[DeleteAllTimers]', name, ' deleted.\n']); 
            end
        end
    end
end