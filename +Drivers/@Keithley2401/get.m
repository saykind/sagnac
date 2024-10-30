function varargout = get(obj, varargin)
    %Parameter/fields get method
    %
    %   Usage example:
    %   v = source.get('voltage'); 
    %   [v, i] = source.get('v', 'i');

    for i = 1:(nargin-1)
        switch varargin{i}
            %Parameters:
            case {'on'}
                o = str2double(obj.query(":output?"));
                varargout{i} = o;
            % source
            case {'source.function', 'function'}
                s = obj.query(":sour:func?");
                s = lower(s(1:end-1));
                varargout{i} = s;
            % source.voltage
            case {'source.voltage.mode', 'voltage.mode'}
                s = obj.query(":sour:volt:mode?");
                s = lower(s(1:end-1));
                varargout{i} = s;
            case {'source.voltage.level', 'voltage.level', 'source'}
                v = str2double(obj.query(":sour:volt:lev?"));
                varargout{i} = v;
            case {'source.voltage.range', 'voltage.range'}
                v = str2double(obj.query(":sour:volt:range?"));
                varargout{i} = v;
            % source.current
            case {'source.current.mode', 'current.mode'}
                s = obj.query(":sour:curr:mode?");
                s = lower(s(1:end-1));
                varargout{i} = s;
            case {'source.current.level', 'current.level'}
                c = str2double(obj.query(":sour:curr:lev?"));
                varargout{i} = c;
            case {'source.current.range', 'current.range'}
                c = str2double(obj.query(":sour:curr:range?"));
                varargout{i} = c;
            % sense
            case {'sense.function'}
                s = obj.query(":sens:func?");
                s = s(1:end-1);
                s = strrep(s, ':DC', '');
                s = strrep(s, '"', '');
                s = lower(s);
                s = strsplit(s, ',');
                s = convertCharsToStrings(s);
                varargout{i} = s;
            case {'sense.function.concurrent'}
                s = str2double(obj.query(":sens:func:conc?"));
                varargout{i} = s;
            % sense.voltage
            case {'sense.voltage.protection', 'voltage.protection'}
                v = str2double(obj.query(":sens:volt:prot?"));
                varargout{i} = v;
            case {'sense.voltage.range'}
                v = str2double(obj.query(":sens:volt:range?"));
                varargout{i} = v;
            % sense.current
            case {'sense.current.protection', 'current.protection'}
                c = str2double(obj.query(":sens:curr:prot?"));
                varargout{i} = c;
            case {'sense.current.range'}
                c = str2double(obj.query(":sens:curr:range?"));
                varargout{i} = c;
            %Fields:
            % measure
            case {'v', 'V', 'volt', 'voltage'}
                message = split(obj.query(":meas:volt?"), ',');
                v = str2double(message{1});
                varargout{i} = v;
            case {'i', 'I', 'curr', 'current'}
                message = split(obj.query(":meas:curr?"), ',');
                c = str2double(message{2});
                obj.current = c;
                varargout{i} = c;
            case {'r', 'R', 'res', 'resistance'}
                message = split(obj.query(":meas:res?"), ',');
                r = str2double(message{3});
                varargout{i} = r;
        end
    end

    
end