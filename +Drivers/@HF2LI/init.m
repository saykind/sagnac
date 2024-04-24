function obj = init(obj, device_id)
    %Connect to the LabOne Data Server

    arguments
        obj Drivers.HF2LI;
        device_id char = '';
    end

    %if nargin < 2, return, end

    % Connect to the LabOne Data Server
    if obj.verbose
        disp('[Drivers.HF2LI.init] Connecting to the LabOne Data Server...');
    end
    try
        ziDAQ('connect', 'localhost', 8005, 1);
    catch ME
        disp('[Drivers.HF2LI.init] Error connecting to the LabOne Data Server.');
        disp(ME.message);
        return
    end

    % Auto-detect the device if the device_id is not provided
    if isempty(device_id)
        if obj.verbose
            disp('[Drivers.HF2LI.init] Auto-detecting the device...');
        end
        try
            device_id = ziAutoDetect();
            disp(['Device ID: ' device_id]);
        catch ME
            disp('[Drivers.HF2LI.init] Error auto-detecting the device.');
            disp(ME.message);
            return
        end
    end

    % Connect to the device
    if obj.verbose
        disp('[Drivers.HF2LI.init] Connecting to the device...');
    end
    try
        ziDAQ('connectDevice', device_id, '1GbE');
    catch ME
        disp('[Drivers.HF2LI.init] Error connecting to the device.');
        disp(ME.message);
        return
    end
    
    % Create an API session
    if obj.verbose
        disp('[Drivers.HF2LI.init] Creating an API session...');
    end
    try
        [obj.id, obj.props] = ziCreateAPISession(device_id, 1);
    catch ME
        warning('[Drivers.HF2LI.init] Error creating an API session.');
        disp(ME.message);
        obj.id = device_id;
        obj.props = '';
    end

    obj.interface = 'ziDAQ';
    obj.address = str2double(device_id(4:end));
    obj.name = "HF2LI";
end