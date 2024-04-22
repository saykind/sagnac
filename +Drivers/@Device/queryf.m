function queryf(obj, msg, varargin)
    %Write formated message to device and read response
    %
    %   Usage example:
    %   loop = 1;
    %   obj.queryf("ramp? %d", loop);
    
    msg = sprintf(msg, varargin{:});
    obj.query(msg);
end