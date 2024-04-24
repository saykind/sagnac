function obj = local(obj)
%Switch between local and remote modes.
    if obj.remote
        obj.write('mode 0');
    else
        obj.write('mode 1');
    end
end