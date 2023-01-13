function varargout = read(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   mag = obj.read('R');
    %   [X, Y] = obj.read('X', 'Y');

    for i = 1:(nargin-1)
        switch varargin{i}
            case {'current', 'curr'}
                current = str2double(query(obj.handle, "LAS:LDI?"));
                varargout{i} = current;
            case {'x', 'X'}
                x = str2double(query(obj.handle, "outp?1"));
                obj.X = x;
                varargout{i} = x;
        end
    end

    
end