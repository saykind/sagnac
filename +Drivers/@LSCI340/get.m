function varargout = get(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   mag = obj.read('R');
    %   [X, Y] = lockin.read('X', 'Y');

    for i = 1:(nargin-1)
        switch varargin{i}
            case {'temp', 'tempA', 'temperature', 'a', 'A'}
                ta = str2double(query(obj.handle, "krdg?a"));
                obj.A = ta;
                varargout{i} = ta;
            case {'tempB', 'b', 'B'}
                tb = str2double(query(obj.handle, "krdg?b"));
                obj.B = tb;
                varargout{i} = tb;
            case {'h', 'htr', 'heater', 'HTR'}
                h = str2double(query(obj.handle, "htr?"));
                varargout{i} = h;
        end
    end

    
end