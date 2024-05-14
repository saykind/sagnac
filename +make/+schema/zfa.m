function schema = zfa()
%Create and save table with instrument information for a given experiment.

    name =      ["voltmeter";        "lockin";];
    driver =    ["Keithley2182A";    "HF2LI";];
    interface = ["gpib";             "ziDAQ";];
    address =   [ 17;                 18120;];
    parameters = { ...
                {nan}; ...
                {} ...
                };
    fields =    { ...
                {'v1'}; ...
                {'x', 'y'}; ...
                };

    schema = table(name, driver, interface, address, parameters, fields);
    schema.Properties.Description = mfilename;
end
