function varargout = get(obj, varargin)
    %Parameter/fields get method
    %
    %   Usage example:
    %   voltmeter.set('channel', 2);
    %   v2 = voltmeter.get('voltage');
    %   ch_num = voltmeter.get('channel'); 
    %   [v1, v2] = voltmeter.get('v1', 'v2');

    for i = 1:(nargin-1)
        switch varargin{i}
            %Parameters:
            %   - channel
            %   - range
            case {'ch', 'CH', 'channel', 'CHANNEL'}
                ch = str2double(obj.query(":sense:channel?"));
                obj.channel = ch;
                varargout{i} = ch;
            case {'r', 'R', 'range', 'RANGE'}
                ch = obj.channel;
                sa = sprintf(":sense:voltage:channel%d:range:auto?", ch);
                a = str2double(obj.query(sa));
                if a == 1
                    r = 0;
                else
                    sr = sprintf(":sense:voltage:channel%d:range?", ch);
                    r = str2double(obj.query(sr));
                end
                obj.range = r;
                varargout{i} = r;
            %Fields:
            %   - v1
            %   - v2
            case {'v', 'volt', 'voltage'}
                v = str2num(obj.query(":sens:data:fres?"));
                if obj.channel == 1
                    obj.v1 = v;
                else
                    obj.v2 = v;
                end
                varargout{i} = v;
            case {'v1', 'volt1', 'voltage1'}
                %ch = obj.get('channel');
                ch = 1;
                if ch ~= 1
                    obj.write(":sens:chan 1"); 
                    v = str2num(obj.query(":sens:data:fres?"));
                    obj.set('channel', ch);
                else
                    v = str2num(obj.query(":sens:data:fres?"));
                end
                obj.v1 = v;
                varargout{i} = v;
            case {'v2', 'volt2', 'voltage2'}
                ch = obj.get('channel');
                obj.write(":sens:chan 2"); 
                v = str2num(obj.query(":sens:data:fres?"));
                obj.v2 = v;
                obj.set('channel', ch);
                varargout{i} = v;
        end
    end

    
end