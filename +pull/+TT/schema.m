function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["tempcont";    "temp"];
    driver =    ["LSCI331";     "LSCI340"];
    interface = ["gpib";        "gpib"];
    address =   [23;           16];
    parameters = {{}; {}};
    fields =    {{'A', 'B', 'S', 'H'}; ...
                 {'A', 'B', 'S', 'H'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Temperature vs time.";
end
