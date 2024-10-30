function varargout = get(obj, varargin)
    %Parameter/fields get method
    %
    %   Usage example:
    %   v = source.get('compliance'); 
    %   [v, i] = source.get('v', 'i');

    for i = 1:(nargin-1)
        switch varargin{i}
            %Parameters:
            case {'on', 'output'}
                o = str2double(obj.query(":output?"));
                varargout{i} = o;
            case {'compliance', 'V', 'v', 'voltage', 'volt'}
                c = str2double(obj.query(":sour:curr:comp?"));
                varargout{i} = c;
            case {'i', 'I', 'curr', 'current'}
                c = str2double(obj.query(":sour:curr?"));
                varargout{i} = c;
        end
    end

    
end