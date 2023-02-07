function out = query(obj, msg)
    %GPIB message sending
    %
    %   Usage example:
    %   id = obj.query('*IDN?');
    
    if ~isstring(msg)
        error("Argument must be a string.");
    end
    if isa(obj.handle, 'visa')
        out = query(obj.handle, msg);
    elseif isa(obj.handle, 'visalib.GPIB')
        out = writeread(obj.handle, msg);
    else
        error(strcat("Unsupported handle: ", class(obj.handle)));
    end
end