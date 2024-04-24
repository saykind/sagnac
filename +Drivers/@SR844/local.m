function obj = local(obj)
%Switch between local and remote modes.
    if obj.remote
        obj.write('locl 0');
    else
        obj.write('locl 1');
    end
end