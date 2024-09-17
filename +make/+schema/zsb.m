function schema = zsb()
%Create and save table with instrument information for a given experiment.

    name =      ["voltmeter";        "lockin";   "lockinA"];
    driver =    ["Keithley2182A";    "HF2LI";    "SR830"];
    interface = ["gpib";             "ziDAQ";    "gpib"];
    address =   [17;                 18120;      12];
    parameters = ...
                {{nan}; ...
                {}; ...
                {}};
    fields =    {{'v1'}; ...
                {'x', 'y'}; ...
                {'ampl'}};

    schema = table(name, driver, interface, address, parameters, fields);
    schema.Properties.Description = mfilename;
end
