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
            case {'position'}
                varargout{i} = obj.position;
        end
    end
end