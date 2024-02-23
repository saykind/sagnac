function varargout = get(obj, varargin)
    %Parameter/field get method
    %
    %   Usage example:
    %   mag = obj.get('R');
    %   [X, Y] = tempcont.get('X', 'Y');

    for i = 1:(nargin-1)
        switch varargin{i}
            case {'temp', 'tempA', 'temperature', 'a', 'A'}
                ta = str2double(query(obj.handle, "krdg?a"));
                obj.A = ta;
                varargout{i} = ta;
            case {'tempB', 'b', 'B'}
                tb = str2double(query(obj.handle, "krdg?b"));
                obj.B = tb;
                varargout{i} = tb;
            case {'h', 'htr', 'heater', 'HTR'}
                h = str2double(query(obj.handle, "htr?"));
                varargout{i} = h;
            case {'heaterRange', 'range'}
                r = str2double(query(obj.handle, "range?"));
                varargout{i} = r;
            case {'rampRate', 'rate'}
                rr = str2num(obj.query("RAMP? 1")); %#ok<ST2NM>
                %obj.rampOn = rr(1);
                %obj.rampRate = rr(2);
                varargout{i} = rr(2);
            case {'rampOn', 'ramp'}
                rr = str2num(obj.query("RAMP? 1")); %#ok<ST2NM>
                %obj.rampOn = rr(1);
                %obj.rampRate = rr(2);
                varargout{i} = rr(1);
            case {'S', 'setpoint'}
                s = str2double(obj.query("SETP? 1"));
                %obj.S = s;
                varargout{i} = s;

        end
    end

    
end