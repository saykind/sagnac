function write(obj, msg)
    %GPIB message sending
    %
    %   Usage example:
    %   obj.write("*IDN?");
    
    % Set values
    if ~isstring(msg) && ~ischar(msg)
        error("Argument must be a string.");
    end
    if isa(obj.handle, 'visa') || isa(obj.handle, 'gpib')
        fprintf(obj.handle, msg);
    elseif isa(obj.handle, 'visalib.GPIB')
        writeline(obj.handle, msg);
    else
        error(strcat("Unsupported handle: ", class(obj.handle)));
    end
end