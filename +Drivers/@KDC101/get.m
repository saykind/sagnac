function varargout = get(obj, varargin)
    %Parameters and fields reading method
    %
    %   Available parameters:
    %   - angle
    %
    %   Usage example:
    %   a = obj.get('position');

    % check if varargin contains 'velocity' or 'acceleration'
    % if so, get the velocity and acceleration parameters
    % and return them as output arguments
    if any(strcmp(varargin, 'velocity')) || any(strcmp(varargin, 'acceleration'))
        velocity_params = obj.handle.GetVelocityParams;
    else
        velocity_params = [];
    end

    for i = 1:(nargin-1)
        switch varargin{i}
            %% Parameters:
            %   - velocity
            %   - acceleration
            %   - backlash
            case {'velocity'}
                varargout{i} = System.Decimal.ToDouble(velocity_params.MaxVelocity);
            case {'acceleration'}
                varargout{i} = System.Decimal.ToDouble(velocity_params.Acceleration);
            case {'backlash'}
                varargout{i} = System.Decimal.ToDouble(obj.handle.GetBacklash);


            %%Fields:
            %   - position
            case {'pos', 'position'}
                a = System.Decimal.ToDouble(obj.handle.Position);
                varargout{i} = a;
                
            otherwise
                util.msg('Unknown argument.');
        end
    end
end