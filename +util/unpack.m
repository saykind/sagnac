function varargout = unpack(inputArray)
%UNPACK does roughly the same thing as a built-in function deal.
%
%   Example:
%       [axisA, axisB, axisC] = util.unpack(graphics.axes);
%
% See also DEAL
    for i = 1:length(inputArray)
        varargout{i} = inputArray(i);
    end
end