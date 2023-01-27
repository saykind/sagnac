function out = query(obj, msg)
    %Simple query method.
    %
    %   Usage example:
    %   id = obj.query("1ID?");
    
    % Set values
    if ~isstring(msg) && ~ischar(msg)
        error("Argument must be a string or char.");
    end
    numBytesAvailable = obj.handle.NumBytesAvailable;
    obj.write(msg);
    % Wait for the device to answer (Timeout ~ 1 sec)
    for i=1:50
        if obj.handle.NumBytesAvailable > numBytesAvailable
            break
        end
        java.lang.Thread.sleep(20); % 15 millisec accuracy
    end
    out = obj.read();
    obj.buffer = obj.handle.NumBytesAvailable;
end