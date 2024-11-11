function obj = init(obj, ~, ~, varargin)
    NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.DeviceManagerCLI.dll');
    NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.GenericMotorCLI.dll');
    NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.IntegratedStepperMotorsCLI.dll');

    import Thorlabs.MotionControl.DeviceManagerCLI.*
    import Thorlabs.MotionControl.GenericMotorCLI.*
    import Thorlabs.MotionControl.IntegratedStepperMotorsCLI.*

    %Set up device and configuration
    device = CageRotator.CreateCageRotator(obj.serial_num);
    device.Connect(obj.serial_num);
    device.WaitForSettingsInitialized(5000);        % DO NOT ACCESS DEVICE UNTIL THIS IS COMPLETE

    motorSettings = device.LoadMotorConfiguration(obj.serial_num);
    currentDeviceSettings = device.MotorDeviceSettings;

    motorSettings.UpdateCurrentConfiguration();
    deviceUnitConverter = device.UnitConverter();

    device.StartPolling(250);
    device.EnableDevice();

    obj.handle = device;
    obj.deviceUnitConverter = deviceUnitConverter;
    obj.motorSettings = motorSettings;
    obj.currentDeviceSettings = currentDeviceSettings;
end