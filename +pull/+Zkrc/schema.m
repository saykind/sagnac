function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["lockin";      "tempcont";     "lockinA";    "bridge"];
    driver =    ["HF2LI";       "LSCI331";      "SR830";    "AH2500A"];
    interface = ["ziDAQ";       "gpib";         "visa";     "gpib"];
    address =   [18120;         23;            12;      28];
    parameters = ...
                {{}; ...
                {nan}; ...
                {nan}; ...
                {nan}};
    fields =    {{'sample'}; ...
                {'A', 'B'}; ...
                {'X', 'Y'}; ...
                {'C'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Kerr, Resistance, Cpacitance vs temperature.";
end
