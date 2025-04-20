function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["tempcont";     "lockin";    "magnet"];
    driver =    ["LSCI331";      "HF2LI";    "KEPCO"];
    interface = ["gpib";         "ziDAQ";     "gpib"];
    address =   [23;            18120;      5];
    parameters = ...
                {{nan}; ...
                {nan}; ...
                {nan}};
    fields =    {{'A', 'B'}; ...
                {'sample'}; ...
                {'I', 'V'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Kerr vs Magnetic field.";
end
