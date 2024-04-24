function obj = local(obj)
%Switch between local and remote modes.
    if obj.remote
        obj.write('system:local');
    else
        obj.write('system:remote');
    end
end