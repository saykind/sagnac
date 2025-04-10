function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["tempcont";     "lockinA";    "bridge"];
    driver =    ["LSCI331";      "SR830";    "AH2500A"];
    interface = ["gpib";         "visa";     "gpib"];
    address =   [23;            12;      28];
    parameters = ...
                {{nan}; ...
                {nan}; ...
                {nan}};
    fields =    {{'A', 'B'}; ...
                {'X', 'Y', 'AUXV1'}; ...
                {'C'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Resistance, Cpacitance vs temperature.";
end
