function varargout = unpack(inputArray)
%UNPACK does the same thing as a built-in function deal.
%
% See also DEAL
    for i = 1:length(inputArray)
        varargout{i} = inputArray(i);
    end
end