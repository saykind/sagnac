function obj = local(obj)
%Switch between local and remote modes.
    if obj.remote
        fprintf(obj.handle, 'system:local');
    else
        fprintf(obj.handle, 'system:remote');
    end
end