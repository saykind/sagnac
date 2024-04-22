function writef(obj, msg, varargin)
    %Write formated message to device
    %
    %   Usage example:
    %   loop = 1;
    %   rate = 2.5;
    %   obj.writef("ramp %d, %d, %.2f", loop, 1, rate);
    
    msg = sprintf(msg, varargin{:});
    obj.write(msg);
end