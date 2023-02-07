function handle = gpib(address)
%Find the instrument given GPIB address
%   Checks if such instrument is already in memeory,
%   If not, creates new instrument.

    try
        handle = visadev(sprintf("GPIB0::%d::INSTR", address));
    catch ME
        if strcmp(ME.identifier, "instrument:interface:visa:multipleIdenticalResources")
            fprintf("GPIB%2d is already somewhere in the memory space.\n", address);
            handle = [];
            return
        end
        if strcmp(ME.identifier, "instrument:interface:visa:unableToDetermineInterfaceType")
            fprintf("GPIB%2d was not found.\n", address);
            handle = [];
            return
        end
    end
end