function varargout = read(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   mag = obj.read('R');
    %   [X, Y] = obj.read('X', 'Y');

    for i = 1:(nargin-1)
        switch varargin{i}
            case 'timeConstant'
                tc = str2double(query(obj.handle, "oflt?"))-8;
                res = 1;
                if mod(tc,2)
                    res = 3;
                    tc = tc -1;
                end
                res = res*power(10,tc/2);
                obj.timeConstant = res;
                varargout{i} = res;
            case {'x', 'X'}
                x = str2double(query(obj.handle, "outp?1"));
                obj.X = x;
                varargout{i} = x;
            case {'y', 'Y'}
                y = str2double(query(obj.handle, "outp?2"));
                obj.Y = y;
                varargout{i} = y;
            case {'R', 'mag'}
                r = str2double(query(obj.handle, "outp?3"));
                obj.R = r;
                varargout{i} = r;
            case {'Q', 'theta'}
                q = str2double(query(obj.handle, "outp?5"));
                obj.Q = q;
                varargout{i} = q;
        end
    end

    
end