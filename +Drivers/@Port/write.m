function obj = write(obj, cmd)
    arguments
        obj;
        cmd (1,1) string;
    end
    %Simple writing method.
    numBytesWritten = obj.handle.NumBytesWritten;
    writeline(obj.handle, cmd);
    if (obj.handle.NumBytesWritten-numBytesWritten) ~= (strlength(cmd)+2)
        warning('Number of bytes written is incorrect.');
    end
    obj.buffer = obj.handle.NumBytesAvailable;
end