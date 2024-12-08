function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["lockin";      "tempcont"];
    driver =    ["HF2LI";       "LSCI331"];
    interface = ["ziDAQ";       "gpib"];
    address =   [18120;         23];
    parameters = ...
                {{}; ...
                {nan}};
    fields =    {{'sample', 'output_amplitude'}; ...
                {'A', 'B'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Kerr vs temperature.";
end
