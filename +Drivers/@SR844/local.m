function obj = local(obj)
%Switch between local and remote modes.
    if obj.remote
        obj.write('locl 0');
        obj.remote = false;
    else
        obj.write('locl 1');
        obj.remote = true;
    end
end