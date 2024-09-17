function sweep(obj, v, dv, dt)
    %if nargin < 4, dt = .2; end
    %if nargin < 3, dv = .005*dt; end
    if dv/dt > .1
        warning("Rate is too high.");
        return
    end
    v0 = obj.get('source');
    v_range = linspace(v0, v, fix(abs(v-v0)/dv)+1);
    for i = 1:numel(v_range)
        obj.set('v', v_range(i));
        pause(dt);
    end
end