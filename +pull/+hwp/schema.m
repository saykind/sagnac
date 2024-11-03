function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["voltmeter";        "lockin";];
    driver =    ["Keithley2182A";    "HF2LI"; ];
    interface = ["gpib";             "ziDAQ";];
    address =   [ 17;                 NaN;];
    parameters = ...
                {{}; ...
                {}};
    fields =    {{'v1'}; ...
                {'x', 'y'}};

    s = table(name, driver, interface, address, parameters, fields);
    
    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Half-waveplate rotation (manual).";
end
    