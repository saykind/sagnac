function delete(obj)
    %Destructor for the Kinesis10CR2 class
    if ~isempty(obj.handle) && isvalid(obj.handle)
        dev_name = string(obj.handle.GetDeviceName());
        obj.handle.StopPolling()
        obj.handle.Disconnect()
        delete(obj.handle);
        util.msg("Device <%s> disconnected.", dev_name);
    end
    obj.handle = [];
end