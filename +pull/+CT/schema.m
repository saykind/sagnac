function s = schema()
%Create and save table with instrument information for a given experiment.

    name =      ["tempcont";    "bridge"];
    driver =    ["LSCI331";     "AH2500A"];
    interface = ["gpib";        "visa";];
    address =   [23;            12;];
    parameters = ...
                { ...
                {nan}; ...
                {nan}};
    fields =    { ...
                {'A', 'B'}; ...
                {'C'}};

    s = table(name, driver, interface, address, parameters, fields);

    % Custom properties
    s = addprop(s,{'Seed', 'SourceFile', 'ExperimentDescription'}, {'table', 'table', 'table'});
    s.Properties.CustomProperties.SourceFile = string(mfilename('fullpath'));
    s.Properties.CustomProperties.ExperimentDescription = "Cpacitance, Temperature vs time";
end
