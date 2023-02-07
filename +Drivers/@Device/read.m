function out = read(obj)
    %GPIB message reading
    %
    %   Usage example:
    %   msg = obj.read();
    
    if isa(obj.handle, 'visalib.GPIB')
        if obj.handle.NumBytesAvailable == 0
            warning('Nothing to read.');
            return
        end
        out = readline(obj.handle);
        return
    end
    if isa(obj.handle, 'visa')
        out = fscanf(obj.handle);
        return
    end
    error(strcat("Unsupported handle: ", class(obj.handle)));
end