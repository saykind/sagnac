function out = read(obj)
    %Simple data reading method.
    obj.buffer = obj.handle.NumBytesAvailable;
    if obj.handle.NumBytesAvailable == 0
        warning('Nothing to read.');
        return
    end
    out = readline(obj.handle);
    obj.buffer = obj.handle.NumBytesAvailable;
end