function varargout = get(obj, varargin)
%Parameters and fields reading method
%   Supported arguments:
%       Fields:
%       - position
%
%   Usage example:
%   pos = obj.get('position');


    for i = 1:(nargin-1)
        switch varargin{i}
            %Fields:
            %   - position
            %   - angle
            case {'position'}
                varargout{i} = obj.position;
            case {'angle'}
                varargout{i} = obj.angle;
        end
    end
end