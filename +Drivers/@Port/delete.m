function delete(obj)
    %Destructor
    %Close serialport handle
    if isvalid(obj.handle)
        port_name = obj.handle.Port;
        delete(obj.handle);
        util.msg("Port %s closed.", port_name);
    end
    obj.handle = [];
end