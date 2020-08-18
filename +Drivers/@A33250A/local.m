function obj = local(obj)
%Switch between local and remote modes.
    if obj.remote
        fprintf(obj.handle, 'system:local');
        obj.remote = false;
    else
        fprintf(obj.handle, 'system:remote');
        obj.remote = true;
    end
end