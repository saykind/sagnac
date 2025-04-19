function obj = init(obj, ~, ~, varargin)
    devCLI = NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.DeviceManagerCLI.dll');
    genCLI = NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.GenericMotorCLI.dll');
    motCLI = NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.KCube.DCServoCLI.dll');

    import Thorlabs.MotionControl.DeviceManagerCLI.*
    import Thorlabs.MotionControl.GenericMotorCLI.*
    import Thorlabs.MotionControl.KCube.DCServoCLI.*

    %Initialize Device List
    DeviceManagerCLI.BuildDeviceList();
    DeviceManagerCLI.GetDeviceListSize();

    serial_num = int2str(obj.serial_num);

    %Set up device and configuration
    device = KCubeDCServo.CreateKCubeDCServo(serial_num);
    pause(.5);
    device.Connect(serial_num);
    pause(.5);
    device.WaitForSettingsInitialized(5000);                            % DO NOT ACCESS DEVICE UNTIL THIS IS COMPLETE
    device.StartPolling(250);

    motorSettings = device.LoadMotorConfiguration(serial_num);
    currentDeviceSettings = device.MotorDeviceSettings;

    motorSettings.UpdateCurrentConfiguration();
    deviceUnitConverter = device.UnitConverter();

    %Pull the enumeration values from the DeviceManagerCLI
    getTypeStr = 'Thorlabs.MotionControl.DeviceManagerCLI.DeviceSettingsSectionBase+SettingsUseOptionType';
    optionTypeHandle = devCLI.AssemblyHandle.GetType(getTypeStr);
    optionTypeEnums = optionTypeHandle.GetEnumValues(); 
    
    %Load Settings to the controller
    motorConfiguration = device.LoadMotorConfiguration(serial_num);
    motorConfiguration.LoadSettingsOption = optionTypeEnums.Get(1);     % File Settings Option
    motorConfiguration.DeviceSettingsName = 'Z925';                     % The actuator type needs to be set here. This specifically loads an PRM1-Z8
    factory = KCubeMotor.KCubeDCMotorSettingsFactory();
    device.SetSettings(factory.GetSettings(motorConfiguration), true, false);

    device.EnableDevice();

    obj.handle = device;
    obj.deviceUnitConverter = deviceUnitConverter;
    obj.motorSettings = motorSettings;
    obj.motorConfiguration = motorConfiguration;
    obj.currentDeviceSettings = currentDeviceSettings;
end