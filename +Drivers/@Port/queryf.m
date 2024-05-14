function out = queryf(obj, fmt, varargin)
    %Write formated message to device and read response
    
    msg = sprintf(fmt, varargin{:});
    out = obj.query(msg);
end