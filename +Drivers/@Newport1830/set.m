function set(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   tempcont.set('wavelength', 1550);
    %   tempcont.set('wavelength', 830, 'filter', 2, 'range', 0);

    % Acquire parameters
    p = inputParser;
    
    addParameter(p, 'filter', NaN);
    addParameter(p, 'range', NaN, @isnumeric);
    addParameter(p, 'units', NaN);
    addParameter(p, 'wavelength', NaN, @isnumeric);
    
    parse(p, varargin{:});
    parameters = p.Results;
    
    % Set values
    if ~isnan(parameters.filter)
        f = parameters.filter;
        if isstring(f), f = convertStringsToChars(f); end
        if ischar(f)
            switch f(1)
                case 'S', f = 1;
                case 'M', f = 2;
                case 'F', f = 3;
                otherwise
                    warning("[Newport1830.set] Uknown filter value.");
            end
        end
        if isnumeric(f)
            obj.filter = f;
            obj.write(sprintf("f%d", f));
        end
    end
    if ~isnan(parameters.range)
        r = parameters.range;
        if (r < 0) || (r > 8)
            warning("[Newport1830.set] Incorrect range value.");
        end
        obj.range = r;
        obj.write(sprintf("r%d", r));
    end
    if ~isnan(parameters.units)
        u = parameters.units;
        if isstring(u), u = convertStringsToChars(u); end
        if ischar(u)
            switch u
                case 'W',   u = 1;
                case 'dB',  u = 2;
                case 'dBm', u = 3;
                case 'REL', u = 4;
                otherwise
                    warning("[Newport1830.set] Uknown units.");
            end
        end
        if isnumeric(u)
            if (u < 0) || (u > 4)
                warning("[Newport1830.set] Units are 1, 2, 3, or 4.");
            else
                units_char = {'W', 'dB', 'dBm', 'REL'};
                obj.units.power = units_char{u};
                obj.write(sprintf("u%d", u));
            end
        end
    end
    if ~isnan(parameters.wavelength)
        w = parameters.wavelength;
        obj.write(sprintf("w%d", int32(w)));
    end
end