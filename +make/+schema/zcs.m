function schema = zcs()
%Create and save table with instrument information for a given experiment.

    name =      ["voltmeter";        "lockin";   "source"];
    driver =    ["Keithley2182A";    "HF2LI";    "Keithley6221"];
    interface = ["gpib";             "ziDAQ";    "gpib"];
    address =   [17;                 18120;      25];
    parameters = ...
                {{nan}; ...
                {}; ...
                {nan}};
    fields =    {{'v1'}; ...
                {'x', 'y'}; ...
                {'current'}};

    schema = table(name, driver, interface, address, parameters, fields);
    schema.Properties.Description = mfilename;
end
