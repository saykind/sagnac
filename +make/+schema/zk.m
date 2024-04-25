function schema = zk()
%Create and save table with instrument information for a given experiment.

    name =      ["voltmeter";        "lockin";      "tempcont";];
    driver =    ["Keithley2182A";    "HF2LI";       "LSCI331"];
    interface = ["gpib";             "ziDAQ";       "gpib"];
    address =   [ 17;                 18120;         23];
    parameters = ...
                {{nan}; ...
                {}; ...
                {nan}};
    fields =    {{'v1'}; ...
                {'x', 'y'}; ...
                {'A', 'B'}};

    schema = table(name, driver, interface, address, parameters, fields);
    schema.Properties.Description = mfilename;
end
