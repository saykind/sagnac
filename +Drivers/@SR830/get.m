function varargout = get(obj, varargin)
    %Parameters and fields reading method
    %   Supported arguments:
    %       Parameters:
    %       - frequency
    %       - phase
    %       - amplitude
    %       - time constant
    %       Fields:
    %       - X = V_real
    %       - Y = V_imaginary
    %       - R = V_magnitude
    %       - Q = V_phase
    %       - AUX1 voltage
    %       - AUX2 voltage
    %
    %   Usage example:
    %   freq = obj.get('fequency');
    %   [freq, ampl] = obj.read('fequency', 'amplitude');

    for i = 1:(nargin-1)
        switch varargin{i}
            %Parameters:
            %   - frequency
            %   - phase
            %   - amplitude
            %   - time constant
            case {'f', 'freq', 'frequency'}
                f = str2double(obj.query("freq?"));
                varargout{i} = f;
            case {'ph', 'phase', 'Phase'}
                phase = str2double(obj.query("phas?"));
                varargout{i} = phase;
            case {'a', 'ampl', 'amplitude'}
                a = str2double(obj.query("slvl?"));
                varargout{i} = a;
            case {'tc', 'timeConstant', 'time_constant'}
                tc = str2double(obj.query("oflt?"))-10;
                res = 1;
                if mod(tc,2)
                    res = 3;
                    tc = tc -1;
                end
                res = res*power(10,tc/2);
                obj.timeConstant = res;
                varargout{i} = res;
            %Fields:
            %   - X = V_real
            %   - Y = V_imaginary
            %   - R = V_magnitude
            %   - Q = V_phase
            %   - AUX1 voltage
            %   - AUX2 voltage
            %   - AUXV1 voltage
            case {'x', 'X', 're', 'real'}
                x = str2double(obj.query("outp?1"));
                obj.X = x;
                varargout{i} = x;
            case {'y', 'Y', 'im', 'imag'}
                y = str2double(obj.query("outp?2"));
                obj.Y = y;
                varargout{i} = y;
            case {'R', 'r', 'mag', 'magnitude', 'abs'}
                r = str2double(obj.query("outp?3"));
                obj.R = r;
                varargout{i} = r;
            case {'Q', 'q', 'theta', 'angle'}
                q = str2double(obj.query("outp?4"));
                obj.Q = q;
                varargout{i} = q;
            case {'aux1', 'AUX1'}
                a = str2double(obj.query("oaux?1"));
                obj.AUX1 = a;
                varargout{i} = a;
            case {'aux2', 'AUX2'}
                a = str2double(obj.query("oaux?2"));
                obj.AUX2 = a;
                varargout{i} = a;
            case {'AUXV1'}
                a = str2double(obj.query("auxv?1"));
                obj.AUXV1 = a;
                varargout{i} = a;
            case {'AUXV2'}
                a = str2double(obj.query("auxv?2"));
                obj.AUXV2 = a;
                varargout{i} = a;
        end
    end
end