function schema = zxy()
%Create and save table with instrument information for a given experiment.

    name =      ["voltmeter";        "lockin";   "X";       "Y"];
    driver =    ["Keithley2182A";    "HF2LI";    "Agilis";  "Agilis"];
    interface = ["gpib";             "ziDAQ";    "serial";  "serial"];
    address =   [17;                 NaN;       5;         6];
    parameters = ...
                {{nan}; ...
                {}; ...
                {nan}; ...
                {nan}};
    fields =    {{'v1'}; ...
                {'x', 'y'}; ...
                {'position'}; ...
                {'position'}};

    schema = table(name, driver, interface, address, parameters, fields);
    schema.Properties.Description = mfilename;
end
