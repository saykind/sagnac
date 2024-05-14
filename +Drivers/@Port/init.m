function obj = init(obj, port, options)
    %Initialize serialport handle

    arguments
        obj;
        port;
        options.baudrate = 9600;
        options.terminator = "CR/LF";
    end

    % Check if port is valid
    if ~isnumeric(port) && ~isstring(port)
        error("Port must be a numeric or string.");
    end
    if isnumeric(port)
        obj.address = port;
        obj.port = "COM" + port;
    end
    if isstring(port)
        obj.port = port;
        assert (contains(port, "COM"), "Argument must be a COM port.");
        obj.address = str2double(port(4:end));
    end

    % Initialize serialport handle
    handle = Drivers.serial(obj.port, options.baudrate, options.terminator);
    if ~isa(handle, 'internal.Serialport')
        error("Failed to initialize serial port %s.", obj.port);
    end
    obj.handle = handle;
    obj.baudrate = options.baudrate;
    obj.terminator = options.terminator;

    if obj.verbose
        util.msg("Serial port %s initialized successfully.", obj.port);
    end
end