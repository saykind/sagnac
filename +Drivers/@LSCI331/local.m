function obj = local(obj)
%Switch between local and remote modes.
    if obj.remote
        obj.write('mode 0');
        obj.remote = false;
    else
        obj.write('mode 1');
        obj.remote = true;
    end
end