function varargout = get(obj, varargin)
    %Parameter set method
    %
    %   Usage example:
    %   status = obj.get('S');
    %   [C, L, V] = obj.read('C', 'L', 'V');

    for i = 1:(nargin-1)
        switch varargin{i}
            case {'S', 'status'}
                sta = obj.query("SH STA");
                fmt = "STATUS     MAV=%d MSS=%d EXE=%d RDY=%d PON=%d URQ=%d CME=%d ONR=%d";
                sts = sscanf(sta, fmt);
                status = struct('MAV', sts(1), ...
                                'MSS', sts(2), ...
                                'EXE', sts(3), ...
                                'RDY', sts(4), ...
                                'PON', sts(5), ...
                                'URQ', sts(6), ...
                                'CME', sts(7), ...
                                'ONR', sts(8));
                obj.status = status;
                varargout{i} = status;
            case {'C', 'capacitance', 'cap'}
                str = obj.query("Q");
                fmt = "C=%f PF L=%f NS V=%f V";
                c = sscanf(str, fmt);
                obj.C = c(1);
                obj.L = c(2);
                obj.V = c(3);
                varargout{i} = c(1);
            case {'V', 'voltage', 'volt'}
                str = obj.query("Q");
                fmt = "C=%f PF L=%f NS V=%f V";
                c = sscanf(str, fmt);
                obj.C = c(1);
                obj.L = c(2);
                obj.V = c(3);
                varargout{i} = c(2);
            case {'Q', 'CLV'}
                str = obj.query("Q");
                fmt = "C=%f PF L=%f NS V=%f V";
                c = sscanf(str, fmt);
                obj.C = c(1);
                obj.L = c(2);
                obj.V = c(3);
                varargout{i} = c;
        end
    end

    
end