function varargout = get(obj, varargin)
    %Parameter/fields get method
    %
    %   Usage example:
    %   [tempA, tempB] = tempcont.get('A', 'B');

    for i = 1:(nargin-1)
        switch varargin{i}
            %Parameters:
            %   - remote
            %   - mode
            %   - pid
            %   - heater (value)
            %   - heater current
            %   - heater state
            %   - heater range
            %   - manual output
            %   - rampOn
            %   - ramp rate
            %   - is ramping
            %   - set temperature
            case {'remote'}
                r = str2double(obj.query("MODE?"));
                obj.remote = r;
                varargout{i} = r;
            case {'mode', 'MODE'}
                m = str2double(obj.query("CMODE?"));
                obj.mode = m;
                varargout{i} = m;
            case {'pid', 'PID'}
                pid = str2num(obj.query("PID?")); %#ok<ST2NM>
                obj.pid = pid;
                varargout{i} = pid;
            case {'hr', 'heaterRange', 'range'}
                hr = str2double(obj.query("RANGE?"));
                obj.heaterRange = hr;
                varargout{i} = hr;
                switch hr
                    case 0
                        obj.heaterMaxCurrent = 0;
                    case 1
                        obj.heaterMaxCurrent = 0.01;
                    case 2
                        obj.heaterMaxCurrent = 0.1;
                    case 3 
                        obj.heaterMaxCurrent = 1;
                    otherwise
                        warning('[LSCI331.get] Unexpected heater range.')
                end
            case {'heaterMaxCurrent', 'maxCurrent'}
                obj.get('heaterRange');
                varargout{i} = obj.heaterMaxCurrent;
            case {'manual', 'manualOutput'}
                mout = str2double(obj.query(sprintf("MOUT? %d", obj.loop)));
                obj.manualOutput = mout;
                varargout{i} = mout;
            case {'rampRate', 'rate'}
                rr = str2num(obj.query("RAMP?")); %#ok<ST2NM>
                obj.rampOn = rr(1);
                obj.rampRate = rr(2);
                varargout{i} = obj.rampRate;
            case {'rampOn', 'ramp'}
                rr = str2num(obj.query("RAMP?")); %#ok<ST2NM>
                obj.rampOn = rr(1);
                obj.rampRate = rr(2);
                varargout{i} = obj.rampOn;
            case {'ramping', 'isRamping', 'rampState'}
                rs = str2double(obj.query("RAMPST?"));
                obj.ramping = rs;
                varargout{i} = rs;
            case {'s', 'S', 'setp', 'settemp', 'setTemp'}
                s = str2double(obj.query("SETP?"));
                obj.S = s;
                varargout{i} = s;
            %Fields:
            %   - temp A
            %   - temp B
            case {'a', 'A', 'tA', 'tempA', 'temperatureA', 'temp', 'temperature'}
                temp = str2double(obj.query("KRDG?A"));
                obj.A = temp;
                varargout{i} = temp;
            case {'b', 'B', 'tB', 'tempB', 'temperatureB'}
                temp = str2double(obj.query("KRDG?B"));
                obj.B = temp;
                varargout{i} = temp;
            case {'h', 'heater', 'htr'}
                h = str2double(obj.query("HTR?"));
                obj.heater = h;
                varargout{i} = h;
                if ~isnumeric(obj.heaterMaxCurrent)
                    obj.get('heaterRange');
                end
                obj.heaterCurrent = h*obj.heaterMaxCurrent;
            case {'heaterCurrent', 'current'}
                obj.get('heater');
                obj.get('heaterRange');
                obj.heaterCurrent = obj.heater*obj.heaterMaxCurrent;
                varargout{i} = obj.heaterCurrent;
            case {'heaterState', 'state'}
                hs = str2double(obj.query("HTRST?"));
                obj.heaterState = hs;
                varargout{i} = hs;
        end
    end

    
end