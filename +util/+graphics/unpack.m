function varargout = unpack(inputArray)
%UNPACK graphics axes and clear them.
%
%   Example:
%       [axisA, axisB, axisC] = util.unpack(graphics.axes);
%
% See also DEAL
    for i = 1:length(inputArray)
        ax = inputArray(i);
        yyaxis(ax, 'right'); cla(ax); 
        yyaxis(ax, 'left'); cla(ax);
        varargout{i} = ax;
    end
end