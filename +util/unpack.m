function varargout = unpack(inputArray)
    for i = 1:length(inputArray)
        varargout{i} = inputArray(i);
    end
end