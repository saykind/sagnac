function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["lockin";   "waveplate"];
    driver =    ["HF2LI";    "Kinesis10CR2"];
    interface = ["ziDAQ";    "Kinesis"];
    address =   [NaN;        55475864];
    parameters = ...
                {{}; ...
                {nan}};
    fields =    {{'sample'}; ...
                {'angle'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Kerr vs waveplate angle.";
end
    