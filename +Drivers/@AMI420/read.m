function varargout = read(obj, varargin)
    %Parameter read method
    %
    %   Usage example:
    %   mag = obj.read('R');
    %   [X, Y] = obj.read('X', 'Y');

    for i = 1:(nargin-1)
        switch varargin{i}
            case {'field'}
                val = str2double(query(obj.handle, "field:magnet?"));
                obj.field = val;
                varargout{i} = val;
            case {'current'}
                val = str2double(query(obj.handle, "current:magnet?"));
                obj.current = val;
                varargout{i} = val;
            case {'voltage'}
                val = str2double(query(obj.handle, "voltage:magnet?"));
                obj.voltage = val;
                varargout{i} = val;
            case {'voltageSupply'}
                val = str2double(query(obj.handle, "voltage:supply?"));
                obj.voltageSupply = val;
                varargout{i} = val;
            case {'programmedField'}
                val = str2double(query(obj.handle, "field:program?"));
                obj.programmedField = val;
                varargout{i} = val;
            case {'programmedCurrent'}
                val = str2double(query(obj.handle, "current:program?"));
                obj.programmedCurrent = val;
                varargout{i} = val;
            case 'state'
                stateNum = str2double(query(obj.handle, "state?"));
                switch stateNum
                    case 1
                        varargout{i} = 'ramping';
                    case 2
                        varargout{i} = 'holding';
                    case 3
                        varargout{i} = 'paused';
                    case 4
                        varargout{i} = 'manual up';
                    case 5
                        varargout{i} = 'manual down';
                    case 6
                        varargout{i} = 'zeroing current';
                    case 7
                        varargout{i} = 'quench detected';
                    case 8
                        varargout{i} = 'heating pswitch';
                    case 9
                        varargout{i} = 'at zero current';
                end
                obj.state = varargout{i};
            case {'pswitchState', 'pswitch', 'switch'}
                val = str2double(query(obj.handle, "pswitch?"));
                obj.pswitchState = val;
                varargout{i} = val;
            case {'pswitchVoltage', 'switchVoltage'}
                val = str2double(query(obj.handle, "voltage:pswitch?"));
                obj.pswitchVoltage = val;
                varargout{i} = val;
            case {'pswitchTime', 'switchTime'}
                val = str2double(query(obj.handle, "pswitch:time?"));
                obj.pswitchTime = val;
                varargout{i} = val;
            case {'coilConstant', 'coilConst'}
                val = str2double(query(obj.handle, "coilconst?"));
                obj.coilConstant = val;
                varargout{i} = val;
            case {'fieldUnits', 'field units'}
                val = str2double(query(obj.handle, "field:units?"));
                switch val
                    case 1
                        obj.fieldUnits = 'T';
                        varargout{i} = 'T';
                    case 0
                        obj.fieldUnits = 'kG';
                        varargout{i} = 'kG';
                end
            case {'rampRateField', 'rampRate'}
                val = str2double(query(obj.handle, "ramp:rate:field?"));
                obj.rampRateField = val;
            case {'rampRateCurrent'}
                val = str2double(query(obj.handle, "ramp:rate:current?"));
                obj.rampRateCurrent = val;
        end
    end

    
end