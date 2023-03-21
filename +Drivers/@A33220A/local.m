function obj = local(obj)
%Switch between local and remote modes.
    if obj.remote
        obj.write('system:local');
        obj.remote = false;
    else
        obj.write('system:remote');
        obj.remote = true;
    end
end