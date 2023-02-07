function obj = init(obj, address, handle, varargin)
    %Object initializator
    %   Arguments:
    %   - gpib_address  Numeric GPIB address of the device
    %   - handle        Device stream of type 'visa' or
    %                   device communitaction objec 'visalib.GPIB'

    if (~nargin || nargin == 1), return, end

    if nargin == 2
        handle = Drivers.gpib(address);
        if isempty(handle)
            warning("GPIB connecton was unsuccessful.")
        end
    elseif ~isa(handle, 'visa') && ~isa(handle, 'visalib.GPIB')
        error("Device constructor accepts visa handles only.");
    end
    
    obj.address = address;
    obj.handle = handle;
end