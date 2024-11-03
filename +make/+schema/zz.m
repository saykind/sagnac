function schema = zz()
%Create and save table with instrument information for a given experiment.

    name =      ["voltmeter";        "lockin";   "Z"];
    driver =    ["Keithley2182A";    "HF2LI";    "Dummy"];
    interface = ["gpib";             "ziDAQ";    "manual"];
    address =   [17;                 NaN;        NaN];
    parameters = ...
                {{}; ...
                {}; ...
                {nan}};
    fields =    {{'v1'}; ...
                {'x', 'y'}; ...
                {'position'}};

    schema = table(name, driver, interface, address, parameters, fields);
    schema.Properties.Description = mfilename;
end
