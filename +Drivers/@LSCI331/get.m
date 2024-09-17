function varargout = get(obj, varargin)
    %Parameter/fields get method
    %
    %   Usage example:
    %   [tempA, tempB] = tempcont.get('A', 'B');

    for i = 1:(nargin-1)
        switch varargin{i}
            % Parameters
            case {'control_mode', 'mode'}
                cm = str2double(obj.query(sprintf("cmode? %d", obj.loop)));
                switch cm
                    case 1
                        cm_str = 'manual';
                    case 2
                        cm_str = 'zone';
                    case 3
                        cm_str = 'open';
                    case 4
                        cm_str = 'autotunePID';
                    case 5
                        cm_str = 'autotunePI';
                    case 6
                        cm_str = 'autotuneP';
                end
                varargout{i} = cm_str;
            case {'control_enable', 'enable'}
                cset = sscanf(obj.query(sprintf("cset? %d", obj.loop)), '%c,%d,%d,%d,%d');
                varargout{i} = cset(4);
            case {'heater_range', 'range'}
                hr = str2double(obj.query("range?"));
                varargout{i} = hr;
            case {'manual_output', 'mout'}
                mout = str2double(obj.query(sprintf("mout? %d", obj.loop)));
                varargout{i} = mout;
            case {'pid', 'PID'}
                pid = str2num(obj.query(sprintf("pid? %d", obj.loop))); %#ok<ST2NM>
                varargout{i} = pid;
            case {'ramp_on', 'ramp'}
                rr = str2num(obj.query(sprintf("ramp? %d", obj.loop))); %#ok<ST2NM>
                varargout{i} = rr(1);
            case {'ramp_rate', 'rate'}
                rr = str2num(obj.query(sprintf("ramp? %d", obj.loop))); %#ok<ST2NM>
                varargout{i} = rr(2);
            case {'ramp_status', 'ramping'}
                rs = str2double(obj.query(sprintf("rampst? %d", obj.loop)));
                varargout{i} = rs;
            

            % Fields
            case {'A', 'a', 'temp_A', 'temp', 'temperature'}
                ta = str2double(query(obj.handle, "krdg?a"));
                varargout{i} = ta; %#ok<*AGROW>
            case {'B', 'b', 'temp_B'}
                tb = str2double(query(obj.handle, "krdg?b"));
                varargout{i} = tb;
            case {'heater', 'H', 'h', 'htr'}
                h = str2double(query(obj.handle, "htr?"));
                varargout{i} = h;
            case {'S', 'setpoint'}
                s = str2double(obj.query("SETP? 1"));
                %obj.S = s;
                varargout{i} = s;


            %FIXME
            case {'heaterMaxCurrent', 'maxCurrent'}
                obj.get('heaterRange');
                varargout{i} = obj.heaterMaxCurrent;
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