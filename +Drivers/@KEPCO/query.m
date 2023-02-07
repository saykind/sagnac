function out = query(obj, msg)
    %GPIB message sending
    %
    %   Usage example:
    %   id = obj.query('*IDN?');
    
    % Set values
    if ~isstring(msg)
        error("Argument must be a string.");
        return
    end
    if isa(obj.handle, 'visa')
        out = query(obj.handle, msg);
    elseif isa(obj.handle, 'visalib.GPIB')
        writeline(obj.handle, msg);
        out = readline(obj.handle);
    else
        error(strcat("Unsupported handle: ", class(obj.handle)));
    end
end