function out = query(obj, msg)
    %GPIB message sending
    %
    %   Usage example:
    %   ind_str = obj.query('IND?');
    
    % Set values
    if ~isstring(msg)
        error("Argument must be a string.");
        return;
    end
    out = query(obj.handle, msg);
end