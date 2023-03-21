function varargout = get(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   freq = obj.get('fequency');
    %   [freq, ampl] = obj.get('fequency', 'amplitude');

    for i = 1:(nargin-1)
        switch varargin{i}
            case {'f', 'freq', 'frequency'}
                f = str2double(obj.query("frequency?"));
                obj.frequency = f;
                varargout{i} = f;
            case {'a', 'ampl', 'amplitude'}
                a = str2double(obj.query("voltage?"));
                obj.amplitude = a;
                varargout{i} = a;
            case {'shift', 'offset'}
                o = str2double(obj.query("voltage:offset?"));
                obj.offset = o;
                varargout{i} = o;
            case {'waveform', 'function', 'wave'}
                f = char(obj.query("function?"));
                f = f(1:end-1);
                obj.waveform = f;
                varargout{i} = f;
            case {'output', "out", 'on'}
                o = str2double(obj.query("output?"));
                obj.on = o;
                varargout{i} = o;
        end
    end

    
end