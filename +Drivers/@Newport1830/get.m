function varargout = get(obj, varargin)
    %Parameter/fields get method
    %
    %   Usage example:
    %   [p, u] = temp.get('power', 'units');

    for i = 1:(nargin-1)
        switch varargin{i}
            %Parameters:
            %   - filter
            %   - range
            %   - units
            %   - wavelength
            case {'f', 'F', 'filter', 'FILTER', 'avg', 'AVG'}
                f = str2num(obj.query("f?"));
                obj.filter = f;
                varargout{i} = f;
            case {'r', 'R', 'range', 'RANGE'}
                r = str2num(obj.query("r?"));
                obj.range = r;
                varargout{i} = r;
            case {'u', 'U', 'units', 'power_units'}
                u = str2num(obj.query("u?"));
                switch u
                    case 1, u = 'W';
                    case 2, u = 'dB';
                    case 3, u = 'dB';
                    case 4, u = 'REL';
                end
                obj.units.power = u;
                varargout{i} = u;
            case {'w', 'W', 'wavelength', 'lambda'}
                w = str2num(obj.query("w?"));
                obj.wavelength = w;
                varargout{i} = w;
            %Fields:
            %   - power
            case {'p', 'P', 'pow', 'power', 'POW', 'POWER'}
                p = str2num(obj.query("d?"));
                obj.power = p;
                varargout{i} = p;
        end
    end

    
end