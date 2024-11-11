function delete(obj)
%Destructor for the HF2LI class

    if obj.verbose
        util.msg('disconnecting from the device and the LabOne Data Server.');
    end

    try 
        ziDAQ('disconnectDevice', obj.id);
    catch ME
        util.msg('Error disconnecting from the device.')
        util.msg(ME.message);
    end

    if obj.verbose
        util.msg('destructed.');
    end
end