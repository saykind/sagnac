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
            %   - time constant
            %   - sensitivity
            %   - harmonic
            case {'freq', 'frequency'}
                f = str2double(obj.query("freq?"));
                obj.frequency = f;
                varargout{i} = f;
            case {'ph', 'phase', 'Phase'}
                phase = str2double(obj.query("phas?"));
                obj.phase = phase;
                varargout{i} = phase;
            case {'tc', 'timeConstant', 'time constant', 'time_constant'}
                tc = str2double(obj.query("oflt?"))-8;
                res = 1;
                if mod(tc,2)
                    res = 3;
                    tc = tc -1;
                end
                res = res*power(10,tc/2);
                obj.timeConstant = res;
                varargout{i} = res;
            case {'sens', 'sensitivity'}
                tc = str2double(obj.query("sens?"))-14;
                res = 1;
                if mod(tc,2)
                    res = 3;
                    tc = tc-1;
                end
                res = res*power(10,tc/2);
                obj.timeConstant = res;
                varargout{i} = res;
            case {'harm', 'harmonic'}
                h = str2double(obj.query("harm?"));
                obj.harmonic = h;
                varargout{i} = h;
            %Fields:
            %   - X = V_real
            %   - Y = V_imaginary
            %   - R = V_magnitude
            %   - Q = V_phase
            %   - AUX1 voltage
            %   - AUX2 voltage
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
                q = str2double(obj.query("outp?5"));
                obj.Q = q;
                varargout{i} = q;
            case {'aux1', 'AUX1'}
                a = str2double(obj.query("auxi?1"));
                obj.AUX1 = a;
                varargout{i} = a;
            case {'aux2', 'AUX2'}
                a = str2double(obj.query("auxi?2"));
                obj.AUX2 = a;
                varargout{i} = a;
        end
    end
end