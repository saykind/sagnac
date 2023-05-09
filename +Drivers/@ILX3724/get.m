function varargout = get(obj, varargin)
    %Parameters and fields reading method
    %   Supported arguments:
    %       Parameters:
    %       - mode
    %       - current
    %       - output
    %
    %   Usage example:
    %   curr = obj.get('current');
    %   [curr, on_off] = obj.read('I', 'output');

    for i = 1:(nargin-1)
        switch varargin{i}
            %Parameters:
            %   - las
            %   - lasmode
            %   - current
            %   - voltage
            %   - tec
            %   - tecmode
            %   - temperature
            %   - resistance
            case {'las', 'output', 'on'}
                on = str2double(obj.query("LAS:OUT?"));
                obj.las = on;
                varargout{i} = on;
            case {'mode', 'lasmode'}
                m = obj.query("LAS:MODE?");
                m = m(1:3);
                mode = 0;
                switch m
                    case "ILB"
                        mode = 1;
                    case "MDI"
                        mode = 2;
                    case "IHB"
                        mode = 3;
                end
                obj.lasmode = mode;
                varargout{i} = mode;
            case {'i', 'I', 'current', 'curr', 'Current'}
                curr = str2double(obj.query("LAS:LDI?"));
                obj.current = curr;
                varargout{i} = curr;
            case {'v', 'V', 'voltage', 'volt', 'Voltage'}
                volt = str2double(obj.query("LAS:LDV?"));
                obj.voltage = volt;
                varargout{i} = volt;
            
            case {'tec'}
                on = str2double(obj.query("TEC:OUT?"));
                obj.tec = on;
                varargout{i} = on;
            case {'tecmode'}
                m = obj.query("TEC:MODE?");
                m = m(1);
                mode = 0;
                switch m
                    case "T"
                        mode = 1;
                    case "R"
                        mode = 2;
                    case "I"
                        mode = 3;
                end
                obj.tecmode = mode;
                varargout{i} = mode;
            case {'T', 'temp', 'temperature', 'Temp', 'Temperature'}
                temp = str2double(obj.query("TEC:T?"));
                obj.temperature = temp;
                varargout{i} = temp;
            case {'R', 'res', 'resistance', 'RES', 'Resistance'}
                res = str2double(obj.query("TEC:R?"));
                obj.resistance = res;
                varargout{i} = res;
        end
    end
end