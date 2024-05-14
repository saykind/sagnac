function writef(obj, fmt, varargin)
    %Write formated message to device
    
    msg = sprintf(fmt, varargin{:});
    obj.write(msg);
end