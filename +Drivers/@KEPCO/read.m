function varargout = read(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   mag = obj.read('R');
    %   [X, Y] = obj.read('X', 'Y');

    for i = 1:(nargin-1)
        switch varargin{i}
            case {'I', 'current', 'curr'}
                I = str2num(obj.query("MEAS:CURR?"));
                obj.I = I;
                varargout{i} = I;
            case {'V', 'voltage', 'volt'}
                V = str2num(obj.query("MEAS:VOLT?"));
                obj.V = V;
                varargout{i} = V;
        end
    end

    
end