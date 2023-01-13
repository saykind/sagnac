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
            case {'phase', 'Phase'}
                phase = str2double(query(obj.handle, "phas?"));
                obj.phase = phase;
                varargout{i} = phase;
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
            case {'aux1', 'AUX1'}
                a = str2double(query(obj.handle, "auxi?1"));
                obj.AUX1 = a;
                varargout{i} = a;
            case {'aux2', 'AUX2'}
                a = str2double(query(obj.handle, "auxi?2"));
                obj.AUX2 = a;
                varargout{i} = a;
        end
    end

    
end