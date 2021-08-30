function obj = send(obj, msg)
    %GPIB message sending
    %
    %   Usage example:
    %   obj.send('IND?');
    
    % Set values
    if ~isstring(msg)
        error("Argument must be a string.");
        return;
    end
    fprintf(obj.handle, msg);
end