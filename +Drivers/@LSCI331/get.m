function varargout = get(obj, varargin)
    %Parameter/fields get method
    %
    %   Usage example:
    %   [tempA, tempB] = temp.get('A', 'B');

    for i = 1:(nargin-1)
        switch varargin{i}
            case {'a', 'A', 'tA', 'tempA', 'temperatureA', 'temp', 'temperature'}
                temp = str2num(obj.query("KRDG?A"));
                obj.tempA = temp;
                varargout{i} = temp;
            case {'b', 'B', 'tB', 'tempB', 'temperatureB'}
                temp = str2num(obj.query("KRDG?B"));
                obj.tempB = temp;
                varargout{i} = temp;
            case {'h', 'heater', 'htr'}
                h = str2num(obj.query("HTR?"));
                obj.heater = h;
                varargout{i} = h;
            case {'s', 'set', 'settemp', 'setTemp', 'SETP?'}
                s = str2num(obj.query("SETP?"));
                obj.setTemp = s;
                varargout{i} = s;
        end
    end

    
end