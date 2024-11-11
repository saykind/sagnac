function varargout = get(obj, varargin)
    %Parameters and fields reading method
    %
    %   Available parameters:
    %   - angle
    %
    %   Usage example:
    %   a = obj.get('angle');

    for i = 1:(nargin-1)
        switch varargin{i}
            %%Fields:
            %   - angle
            case {'a', 'angle'}
                a = System.Decimal.ToDouble(obj.handle.Position);
                varargout{i} = a;
                
            otherwise
                util.msg('Unknown argument.');
        end
    end
end