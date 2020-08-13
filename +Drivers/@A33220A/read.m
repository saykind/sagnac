function varargout = read(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   freq = obj.read('fequency');
    %   [freq, ampl] = obj.read('fequency', 'amplitude');

    for i = 1:(nargin-1)
        switch varargin{i}
            case 'frequency'
                f = str2double(query(obj.handle, "frequency?"));
                obj.frequency = f;
                varargout{i} = f;
            case 'amplitude'
                a = str2double(query(obj.handle, "voltage?"));
                obj.amplitude = a;
                varargout{i} = a;
            case 'offset'
                o = str2double(query(obj.handle, "voltage:offset?"));
                obj.offset = o;
                varargout{i} = o;
            case 'function'
                f = char(query(obj.handle, "function?"));
                f = f(1:end-1);
                obj.functionform = f;
                varargout{i} = f;
        end
    end

    
end