function varargout = get(obj, varargin)
    %Parameter/fields get method
    %
    %   Usage example:
    %   v = source.get('voltage'); 
    %   [v, i] = source.get('v', 'i');

    for i = 1:(nargin-1)
        switch varargin{i}
            %Parameters:
            %   - range
            %Fields:
            %   - voltage
            %   - current
            case {'source'}
                v = str2double(obj.query(":SOUR:VOLT:LEV?"));
                varargout{i} = v;
            case {'v', 'V', 'volt', 'voltage'}
                message = split(obj.query(":meas:volt?"), ',');
                v = str2double(message{1});
                varargout{i} = v;
            case {'i', 'I', 'current'}
                message = split(obj.query(":meas:curr?"), ',');
                c = str2double(message{2});
                obj.current = c;
                varargout{i} = c;
        end
    end

    
end