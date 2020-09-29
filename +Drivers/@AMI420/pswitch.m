function obj = pswitch(obj)
%Press pswitch button.
    if obj.pswitchState
        obj.set('pswitch', 0);
    else
        obj.set('pswitch', 1);
    end
end