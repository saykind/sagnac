function varargout = get(obj, varargin)
    %Parameter/fields get method
    %
    %   Usage example:
    %   v = voltmeter.get('voltage');
    %   [v1, v2] = voltmeter.get('v', 'v');

    for i = 1:(nargin-1)
        switch varargin{i}
            %Fields:
            %   - v
            case {'v', 'volt', 'voltage', 'V'}
                v = str2double(obj.query('OUTPUT 707; "F0XG1X"'));
                obj.v = v;
                varargout{i} = v;
        end
    end

    
end