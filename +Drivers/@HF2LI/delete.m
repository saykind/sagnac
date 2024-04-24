function delete(obj)
%Destructor for the HF2LI class

    if obj.verbose
        disp('[Drivers.HF2LI.delete] disconnecting from the device and the LabOne Data Server.');
    end

    try 
        ziDAQ('disconnectDevice', obj.id);
    catch ME
        disp('[Drivers.HF2LI.delete] Error disconnecting from the device.')
        disp(ME.message);
    end

    if obj.verbose
        disp('[Drivers.HF2LI.delete] destructed.');
    end
end