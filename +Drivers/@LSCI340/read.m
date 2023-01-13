function varargout = read(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   mag = obj.read('R');
    %   [X, Y] = lockin.read('X', 'Y');

    for i = 1:(nargin-1)
        switch varargin{i}
            case {'temp', 'temperature', 'a', 'A'}
                ta = str2double(query(obj.handle, "krdg?a"));
                obj.tempA = ta;
                varargout{i} = ta;
            case {'b', 'B'}
                tb = str2double(query(obj.handle, "krdg?b"));
                obj.tempB = tb;
                varargout{i} = tb;
            case {'h', 'htr', 'heater', 'HTR'}
                h = str2double(query(obj.handle, "htr?"));
                varargout{i} = h;
        end
    end

    
end