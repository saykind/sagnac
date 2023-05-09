function obj = local(obj)
%Switch between local and remote modes.
    if obj.remote
        obj.write('l1');
        obj.remote = false;
    else
        obj.write('l0');
        obj.remote = true;
    end
end