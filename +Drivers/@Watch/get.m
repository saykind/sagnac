function varargout = get(obj, varargin)
%Parameters and fields reading method
%   Supported arguments:
%       Fields:
%       - datetime
%       - clock
%
%   Usage example:
%   c = obj.get('clock');
%   dt = obj.get('datetime');
%   [c, dt] = obj.read('c', 'dt');

    dt = datetime('now');
    c = [year(dt), ...
         month(dt), ...
         day(dt), ...
         hour(dt), ...
         minute(dt), ...
         second(dt)];

    for i = 1:(nargin-1)
        switch varargin{i}
            %Fields:
            %   - datetime
            %   - clock
            case {'datetime', 'dt', 'now'}
                obj.clock = c;
                obj.datetime = dt;
                varargout{i} = dt;
            case {'clock', 'c'}
                obj.clock = c;
                obj.datetime = dt;
                varargout{i} = c;
        end
    end
end