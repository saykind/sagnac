function obj = init(obj, address, handle, varargin)
    %Initialize GPIB handle
    %   Arguments:
    %   - address       Numeric GPIB address of the device
    %   - handle        Device stream of type 'gpib' or 'visa' or
    %                   device communitaction object 'visalib.GPIB'

    if (~nargin || nargin == 1), return, end

    if nargin == 2
        %Available options:
        %   handle = Drivers.gpib(address);
        %   handle = Drivers.visa(address);
        %   handle = Drivers.visadev(address);
        handle = Drivers.(obj.interface)(address);
        if isempty(handle)
            warning("GPIB connecton was unsuccessful.")
        end
    elseif ~isa(handle, 'visa') && ~isa(handle, 'visalib.GPIB')
        error("Device constructor accepts visa handles only.");
    end
    
    obj.address = address;
    obj.handle = handle;
end