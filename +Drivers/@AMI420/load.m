function obj = load(obj, gpib, handle)
%   Object creation method

    if nargin == 2
        handle = Drivers.find_instrument(gpib);
    end

    if ~isa(handle, 'visa')
        error("AMI420 requires valid visa handle or GPIB address.");
    end

    obj.gpib = gpib;
    obj.handle = handle;
    obj.idn = sprintf("%s_%02d", obj.name, obj.gpib);

    % Set to REMOTE (if not set already)
    fprintf(handle, 'system:remote');
    obj.remote = true;

    % Test read
    obj.update();