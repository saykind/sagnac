function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["voltmeter";        "lockin";   "Z"];
    driver =    ["Keithley2182A";    "HF2LI";    "Manual"];
    interface = ["gpib";             "ziDAQ";    ""];
    address =   [ 17;                 NaN;        NaN];
    parameters = ...
                {{}; ...
                {}; ...
                {nan}};
    fields =    {{'v1'}; ...
                {'x', 'y'}; ...
                {'position'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Kerr angle as a function of z-position.";
end
    