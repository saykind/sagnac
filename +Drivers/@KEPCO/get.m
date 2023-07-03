function varargout = get(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   mag = obj.read('R');
    %   [X, Y] = obj.read('X', 'Y');

    for i = 1:(nargin-1)
        switch varargin{i}
            case {'on', 'output'}
                o = str2double(obj.query("OUTPUT?"));
                obj.on = o;
                varargout{i} = o;
            case {'I', 'current', 'curr'}
                I = str2double(obj.query("MEAS:CURR?"));
                obj.I = I;
                varargout{i} = I;
            case {'V', 'voltage', 'volt'}
                V = str2double(obj.query("MEAS:VOLT?"));
                obj.V = V;
                varargout{i} = V;
            case {'Vlim', 'voltageLimit', 'voltlim'}
                vlim = str2double(obj.query("VOLTAGE:LIMIT:HIGH?"));
                obj.voltageLimit = vlim;
                varargout{i} = vlim;
            case {'Ilim', 'currentLimit', 'currlim'}
                ilim = str2double(obj.query("CURRENT:LIMIT:HIGH?"));
                obj.currentLimit = ilim;
                varargout{i} = ilim;
            % internal parameters
            case {'coilConstant', 'constant'}
                o = obj.coilConstant;
                varargout{i} = o;
        end
    end

    
end