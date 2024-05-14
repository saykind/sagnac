function varargout = get(obj, varargin)
%GET  Get the value of the field or parameter.
%
%   Example:
%   v = obj.get('voltage');

for i = 1:(nargin-1)
    switch varargin{i}
        % Parameters
        case {'mode'}
            status = obj.queryf("READ%dS", obj.add);
            status = char(status);
            mode = str2double(status(2));
            switch mode
                case 1
                    mode_str = 'Q+';
                case 2
                    mode_str = 'Q-';
                case 3
                    mode_str = 'MAX';
                case 4
                    mode_str = 'MIN';
                case 5
                    mode_str = 'Manual';
            end
            varargout{i} = mode_str;
        case {'voltage'}
            value = str2double(obj.queryf("READ%dV", obj.add));
            voltage = obj.voltage_max - obj.voltage_coeff * value;
            varargout{i} = voltage;
        case {'vpi'}
            value = str2double(obj.queryf("READ%dVPI", obj.add));
            vpi = obj.voltage_coeff * value;
            varargout{i} = vpi;
        case {'optical_power'}
            status = obj.queryf("READ%dS", obj.add);
            status = char(status);
            value = str2double(status(3:end));
            power = obj.optical_power_coeff * value;
            varargout{i} = power;
    end
end

